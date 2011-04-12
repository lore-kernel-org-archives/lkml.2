Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab1DLSIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:08:15 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:40035 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754731Ab1DLSIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:08:13 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 3g9V1DgVM1lDH_C1vs32eCv0jXOtqTKO3yjmlpeQTZAziDs
 cafkCXBaL_ikDoWE65mU9Wnxz4HElYF0eYzxjsfou0sz1W4Ha.T3rzqV4GXp
 jpe4RWWv0cSTWxa9khtAyYJAX9igPZlxR6lRId3vMf20Q4RJxEHAlXHxHEEK
 iw27oGGuv0EhXFWFTDqP20sXxl71G_Am8vBaAZ9BB9HRTrY09xOoYMKVj2BN
 qRQL9.l2ZP0i.pxWOD76HWbPpj3G4iSjiPeepa82n8E2XSMDOykOlKA09ewu
 5Co49YRddLDfbCiVMyBxubw5bvD7hZkMMpUjoWkInB3RalqpM
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 12 Apr 2011 13:08:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Kruse <pk@q-leap.de>
cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
In-Reply-To: <4DA4692D.7080207@q-leap.de>
Message-ID: <alpine.DEB.2.00.1104121306581.14692@router.home>
References: <4D53FE43.8030106@q-leap.com>    <alpine.DEB.2.00.1102141046170.26158@router.home>    <4D5A2EDB.8060603@q-leap.com>    <alpine.DEB.2.00.1102151040560.10511@router.home>    <4D5BC16A.2090205@q-leap.com>    <alpine.DEB.2.00.1102160956250.27814@router.home>
    <4D5BF56F.1000504@q-leap.com>    <alpine.DEB.2.00.1102161010330.27814@router.home>    <4D5CCEED.3010501@q-leap.com>    <alpine.DEB.2.00.1102171102520.11140@router.home> <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de> <4D6648B5.1090306@q-leap.com>
 <4DA4692D.7080207@q-leap.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <alpine.DEB.2.00.1104121306583.14692@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Peter Kruse wrote:

> Hello,
>
> On 02/24/2011 01:01 PM, Peter Kruse wrote:
> > it took a while to find a date for a reboot... Unfortunately
> > it was not possible to get the early boot messages with the
> > kernel 2.6.32.23 since the compiled in log buffer is too
> > small. So we installed as you suggested a more recent kernel
> > 2.6.32.29 with a bigger log buffer, I attach the dmesg
> > of that, and hope that the information in there is useful.
> > We will keep an eye on that server with the newer kernel
> > to see if the allocation failures appear again.
>
> the server was running for a few without any more allocation
> failures with kernel 2.6.32.29 but at one point the server
> stopped responding, it was still possible for a while to
> get a login, and trying to kill some processes but that
> didn't succeed.  But after that even login was
> no longer possible so we had to reset it.
> I attach the call trace, I hope you can find out what is
> the problem.

The problem maybe that you have lots and lots of SCSI devices which
consume ZONE_DMA memory for their control structures. I guess that is
oversubscribing the 16M zone.

