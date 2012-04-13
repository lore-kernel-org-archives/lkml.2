Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab2DMTzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:55:04 -0400
Received: from nm33-vm5.bullet.mail.bf1.yahoo.com ([72.30.239.205]:45656 "HELO
	nm33-vm5.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755746Ab2DMTzD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:55:03 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2012 15:55:02 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 932965.66374.bm@omp1045.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=rYipjUTcHRucB0qaEiiymUG8o8TIKU8ur9AlAgwvV7CGsjJnunmldm12T6VZNrAexBusC1gkkLOfdz70f0xCP/fD06cxf1lqKIshJz68/LtAZl0iPyDQuDLQKKqLgzuSWDtoL5zeMSreLFD+CIJt+zD1PopQQ6SG+LOjvJ6tVxo=;
X-YMail-OSG: mJqD8FIVM1ln.YYxugLoZrOWWG.Y4L_k8zrED4SLNIroey0
 6oGODVgmqEqDdtGUyUM3Su1iK3f4N6lY2BJxqh_WIxZdXDecvRHHr8j6XsLe
 YSf6WOOYst0GQeCRYpf5kIiSKrMxWfiyZl1btOa6bwUP_c8muAfdmAHpliWN
 FpaEf9WyG.Ek90qyYDwo1kUVbbfUF381CkZdjcYRm2lSrdUPYmdLGJjdagxs
 Dz0WPlmFwSx0GeXQVGgELyY5WtUEtO9BPjsmjXVGgJfdCex1OV3A2eemBzMj
 2NCLetCPVzeTVUNry5RVGRqryYgYzvlNgF_TyTXCJH5jw1gE_3nNzqQ_4J7y
 SgrjpcgYqhfulARojwxdjiA3yLpo71IJW2pZz90ugdDuNLWS.RCCAkk514Sr
 rzRe1QfcQmbu2iiyxhZymvwKIn9nKY8xcbLVnUOMLg850NmK97qoHwsJ8zAr
 ScynSUmNZ3Q5wjzY83AWlOdpp59OpM3zZrWATHxOM4e.ZK_uYZkbObzGGo_1
 qq9cbnmr4k9DlgrVSxXje.z.2WGPlNeFLeyTEkrIpU030.WLFnFouu1KT12D
 D.2j1s3I2nqvZqp7XuRHqTFQ-
X-Mailer: YahooMailWebService/0.8.117.340979
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204132118.22074.rjw@sisk.pl>
Message-ID: <1334346546.93033.YahooMailNeo@web161806.mail.bf1.yahoo.com>
Date: Fri, 13 Apr 2012 12:49:06 -0700 (PDT)
From: Mikko Vinni <mmvinni@yahoo.com>
Reply-To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jean Guyader <jean.guyader@eu.citrix.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <201204132118.22074.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki:

> On Friday, April 13, 2012, Mikko Vinni wrote:
>>  Bug report:
>>     https://bugzilla.kernel.org/show_bug.cgi?id=43099
>> 
>>  Briefly:
>> 
>>  After s2ram the touchpad on a HP dv5 laptop doesn't work anymore.
>> 
>>  dmesg contains this about the touchpad
>>  Apr 11 18:00:05 koni kernel: i8042: Can't write CTR while closing AUX 
> port
>>  Apr 11 18:00:08 koni kernel: i8042: Can't reactivate AUX port
>> 
>> 
>>  Full log in bugzilla with PCI and i8042 debug turned on.
>> 
>>  Bisected to:
>> 
>>  commit 26f41062f28de65e11d3cf353e52d0be73442be1
>>  Author: Kay, Allen M <allen.m.kay@intel.com>
>>  Date:   Thu Jan 26 10:25:53 2012 -0800
>> 
>>      PCI: check for pci bar restore completion and retry
>>     
>>      On some OEM systems, pci_restore_state() is called while FLR has not 
> yet
>>      completed.  As a result, PCI BAR register restore is not successful.  
> This fix
>>      reads back the restored value and compares it with saved value and 
> re-tries 10
>>      times before giving up.
> 
> Does reverting the above commit on top of the current Linus' tree fix the
> problem for you?


It does (at least with the tree from yesterday, 4166fb64593514ad920b7dbd290e0a934b37d24a).


Mikko

> 
> Rafael
> 
