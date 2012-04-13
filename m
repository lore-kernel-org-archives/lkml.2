Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934735Ab2DMJ7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:59:25 -0400
Received: from nm6.bullet.mail.bf1.yahoo.com ([98.139.212.165]:35130 "HELO
	nm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932087Ab2DMJ7X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:59:23 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2012 05:59:23 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 942263.2025.bm@omp1066.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=O/xoAsHZwX3awqLzYePgNTiYBIEARp0NCG8shkru0DtxFu9XN6USt+IuD++NNLDB9ccNjuQH7AYVqaED+xsEGM7S7qhk/BPH3VUz09KNDdVxqqFruOBTCNEUdKXGAdnDRlv/En4AG2bGd5WuO9DPdBP4S76syExnGzqx+Bpz9xk=;
X-YMail-OSG: cgCUUSYVM1ncL.5Ocg3zyy6WSnK3PtJoS4CqRhVpt4s4Ajv
 IQZcmWT7GEdK_r9qnTh47Uj7bPSWFGratp6whSB.6nmUEzxwFT.tmujiensf
 JgP1_MJ6_qn8nB.s3AMPdReSoWqn4jJhnhy5tyNs7G5O2vvs2esJfl1zVLl2
 p8rEUd_ehTstefIrZAhS3IodpGgCU.GIP_Slgw1uciWDO646UhTpo_2O2C7t
 OUs.mB1Y_aSsI7ODoc5FRGQnxcdz0GdicGFw87xxA6EEMEGDogpmXmJ5850j
 JuFANZowmyoRmnh5A9Jannj.W1lG6oXMuz8WJRuhttCcoDj.dNL8n6iiUIZD
 U.DV_9b.D7xTy_R37wYSRWOTWVmdBU704acoZy3fo.eR_kqLinrOF4Meh4Ia
 u5Gue0qE5IglspyXAiZO5xx.P6HNNrczm_Y.kjPJbNDY3nGm0lf7Sbvvjena
 Puw9z2jQ6xo4Ht4H6Kj.kSlx8aCBq5zy3Dve.r9F6aKdcrhDwemzVGycTpot
 R1sW2a_eS_b4d8_3P8BnTcI4nB9PeY5xJhrT6yOsOuGTrct3J33jWw7kqTQ-
 -
X-Mailer: YahooMailWebService/0.8.117.340979
Message-ID: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com>
Date: Fri, 13 Apr 2012 02:52:34 -0700 (PDT)
From: Mikko Vinni <mmvinni@yahoo.com>
Reply-To: Mikko Vinni <mmvinni@yahoo.com>
Subject: "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
To: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jean Guyader <jean.guyader@eu.citrix.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Allen Kay <allen.m.kay@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug report:
    https://bugzilla.kernel.org/show_bug.cgi?id=43099

Briefly:

After s2ram the touchpad on a HP dv5 laptop doesn't work anymore.

dmesg contains this about the touchpad
Apr 11 18:00:05 koni kernel: i8042: Can't write CTR while closing AUX port
Apr 11 18:00:08 koni kernel: i8042: Can't reactivate AUX port


Full log in bugzilla with PCI and i8042 debug turned on.

Bisected to:

commit 26f41062f28de65e11d3cf353e52d0be73442be1
Author: Kay, Allen M <allen.m.kay@intel.com>
Date:   Thu Jan 26 10:25:53 2012 -0800

    PCI: check for pci bar restore completion and retry
    
    On some OEM systems, pci_restore_state() is called while FLR has not yet
    completed.  As a result, PCI BAR register restore is not successful.  This fix
    reads back the restored value and compares it with saved value and re-tries 10
    times before giving up.


I will try to update the BIOS on this laptop next week, hoping that it might
fix some of the s2ram issues, but other than that, maybe somebody has an idea?


Thanks,

Mikko

