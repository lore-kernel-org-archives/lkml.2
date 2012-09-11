Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab2IKNiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:38:09 -0400
Received: from nm23-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.57]:40354 "EHLO
	nm23-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755632Ab2IKNiG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:38:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 914571.46842.bm@omp1008.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=lnHHrKiPiQP4XdkBcWdQle6iKoExEqvl6xzlRXZPTUm4sC0J6lgGQsqat3Ztirz6WEF+OySai7pSX8IcBub0GrlHtHJSDhw6mmYj82q8LGjewlxLQwAS+9KQ/eKy5hdLoDumcJU7mcAf7sTbxRuNN8IEpSyQOlZN3zJQMSUaWuM=;
X-YMail-OSG: iytUFYUVM1lB6ctKUosvXdWFUc4L58.fL9KlxTUqmnLgPZc
 dtFvH01gMzQ13X04QdzBgpwKjWvgyUGSmlx0Rc.zRlQgUJl1dzm07vEX9Sd1
 jRncPLoggSZcWv0jySz07FsggU9lw783y5zVJzb2jcYrBS4rC_C1wgqDaUGO
 qqE3nz36FjV2pZwAD873P3HwFmimDUXRrIy8TSMN6nTv8babF0SouEh3rObA
 cb6PWLg.8uzc22dnQF96kfImYQWDGxx71sG73UWk3W.B3dLN4qyAMOQptuVM
 3u.El6hIuqA2qbW68jHQ7TmWriDuVZxrEQEuYRe4CfeH9pehZqSoVjVfgSlD
 1GaC2KZetZ0JbdXOOJT6cVW2NVnA6CLtEsxTmY1xJHwhzdyrTFtXps7f3vNT
 eLNw7u953PSc5Xb1WaYQnv83.nTrBSWwNp5cstXxgs5FbWt.niSEYWWGaDF7
 o12H8t1ybRUk.lT8MtjM9s6sMhK7_I4w1_2kZ.6Kw2dGAZ1IT4A--
X-Mailer: YahooMailWebService/0.8.121.416
References: <1345901771.8871.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20120826130152.GA20021@liondog.tnic> <1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com> <20120827215952.GA18719@liondog.tnic> <1346259574.81504.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20120830095808.GB24680@liondog.tnic> <1346325007.23643.YahooMailNeo@web124706.mail.ne1.yahoo.com> <20547.48101.900727.735398@pilspetsen.it.uu.se> <1347017576.44763.YahooMailNeo@web124703.mail.ne1.yahoo.com> <20555.29361.138287.766030@pilspetsen.it.uu.se>
Message-ID: <1347370684.63365.YahooMailNeo@web124706.mail.ne1.yahoo.com>
Date: Tue, 11 Sep 2012 06:38:04 -0700 (PDT)
From: Adko Branil <adkobranil@yahoo.com>
Reply-To: Adko Branil <adkobranil@yahoo.com>
Subject: Re: HDD problem, software bug, bios bug, or hardware ?
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Borislav Petkov <bp@alien8.de>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide <linux-ide@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Dan Merillat <dan.merillat@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20555.29361.138287.766030@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael writes:


>Please try the patch below, which implements the fix I described a
>week ago. It's for 3.6-rc4 but should work in any recent kernel.
>Without this patch one of my test machines always throws a lockdep
>warning involving pdc_sata_hardreset and pdc_interrupt during bootup,
>but with the patch the warning is gone, as expected.

>If it works for you I'll add your Tested-by: and submit it properly.



Your patch seems to work, as the warning message is gone after applying it, i tried it with linux-3.5.2,
 and post here links to dmesg before and after applying the patch:

before: http://pastebin.com/Y80AYYVK

after:    http://pastebin.com/Am0Zuabz



Borislav writes:

>Hmm, Cool'n'Quiet enabled actually means that you have _PSS objects and
>powernow-k8 should be detecting the P-states properly.

>Can you catch dmesg from that machine twice?

>* one with Cool'n'Quiet disabled
>* one with the kernel panic


I hope i will be able to do it some time in the future, because i have no any physical contact with this machine,
moreover it will require photo of the monitor after panic message, as it happens at boot process - fs not mounted yet,
network not set, so i can not catch a message with netconsole.


Borislav writes:

>Right, so AFAICU, you can run a CONFIG_PREEMPT kernel perfectly fine now
>after the BIOS update, right?

Right.


Borislav writes:

>If so and when you say that the oopses started happening after an
>electrical instability, I'd venture a guess that something got damaged
>in the BIOS EPROM and since you've flashed it anew, the corrupted data
>got overwritten and so no more crashes. Correct?


The thought crossed my mind, but i still can not imagine how could it happens.
Even if bios keeps some of the settings into EPROM, instead of CMOS, 
it should flash itself just after changing the settings, which is not the case, if i was right informed.
There may be some other way that electricity break could damage EPROM content, somehow more directly,
beyond the mechanisms by design, i don't know.
Anyway, for the known facts we have, this explanation sounds pretty satisfactory, as long as no more crashes appears :).


Thanks !

Regards
Adko.
