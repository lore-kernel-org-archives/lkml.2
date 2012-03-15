Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976Ab2COOx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:53:27 -0400
Received: from nm4.bullet.mail.bf1.yahoo.com ([98.139.212.163]:25390 "HELO
	nm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760929Ab2COOxZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:53:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 182977.10761.bm@omp1050.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=joLIHU+XZ2itqOYkHadQyNVJqD2WlHvRX41ebKle7Tgy4Hy3+juran6ppsjFYeqQ/qu9NpInTr0QHJjKJyR+dxUNCp3hp7OStfl7MHItjG6xZ9EC6ecgLdFfAXqN5SdKx0fOTfOMHbPVJi8llFqKc0HTyQS8aN9FmUsajB2YeEE=;
X-YMail-OSG: a4EOhJIVM1mHJnW3kAaPVocdnt4268JKGuiD2.3DM1s8psn
 Wu6YT5QyUqHs4D9EQZEADzSxPbVzFethJIEHv1gZDhfVL1r2Yksf1.fEMG7p
 yKz4mK.R8EdpFLSUiM.ZTs_1eEL0v2H99ly06ymgvS9ikEtEwqIOTTqJ9cfe
 gUmFPoGwT3c4Oq5vBx76Zz.WKH6sWF3D0qdmBuHdfmUyV2Jk8iaQZZlhMaxW
 NcOlQCP.ET4O5SFT4yBQVre8LqcGehwwkN9zDOP.3jFvWN8.kyglxiMF1Gg3
 scj1exRQWak9EU1.xgsryuQAf9nw4E_zEy2ouwjci70pVyztZ_E7WfyfEvfB
 lAu788M0n.Z3lE0zQATtiBQR.X0QrSKhG0LXu_7rUF4vZFGAlBYRSA5OORnS
 JQlJ2WieWqoWG8i.Pdz70HLVGBIZS1husdOwTaI26RgvxcuriYdXxIxCk0lu
 ME0ABGqsaSyEVVIgRzUnmtqrseeuxdwKUm5JBoYJfNYuoDU4KCA--
X-Mailer: YahooMailWebService/0.8.116.338427
References: <28119509.96581331614425960.JavaMail.weblogic@epml27> <201203132136.56353.rjw@sisk.pl>            <1331720518.14716.YahooMailNeo@web162005.mail.bf1.yahoo.com> <10238.1331746385@turing-police.cc.vt.edu>
Message-ID: <1331823203.99847.YahooMailNeo@web162001.mail.bf1.yahoo.com>
Date: Thu, 15 Mar 2012 07:53:23 -0700 (PDT)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: [INFO] : Hibernation and Resume between 2 similar devices
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <10238.1331746385@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
> To: PINTU KUMAR <pintu_agarwal@yahoo.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
> Sent: Wednesday, 14 March 2012 11:03 PM
> Subject: Re: [INFO] : Hibernation and Resume between 2 similar devices
> 
> On Wed, 14 Mar 2012 03:21:58 PDT, PINTU KUMAR said:
>> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> > Not out of the box (you'd need to hack the kernel for that to work 
> I think,
>> > at least on x86) and the devices would need to be _exactly_ identical.
>> > Moreover, if there is read-write mass storage in them, the filesystems 
> on
>> > both would have to be exactly identical as well (including metadata 
> and data
>> > layout etc.).
> 
>> Suppose in "Device 1" during hibernation, I have a file say 
> "file1.txt" opened whose inode number is say "123456".
>> This opened state of file1.txt will be captured in hibernation image.
>> Now assume that same "file1.txt" is also present (not opened) in 
> "Device2" but whose inode number is say "567890".
>> Now if I reboot "Device 2" and try to resume from hibernated 
> image of "Device 1", what would happen to "file1.txt" ??
> 
> Rafael was quite clear - the mass storage has to be *identical*.  You reboot
> with the image of "Device 1", that had file1.txt open, what will 
> happen when
> you close (or write, or sync) the file is this:
> 
> 1) You'll write data out to disk into whatever blocks were owned by inode
> 12345, no matter who actually owns them on Device2's storage.
> 
> 2) You'll write out inode 12345 to disk, no matter what used to be there.
> 
> Note that you'll do this same thing for *every single* file that was open 
> when
> you hibernated, which means you'll corrupt every file that was opened *and*
> every file that was closed but was using the same blocks on the new disk as the
> open file was using on the original disk.
> 
> In short, you just completely corrupted the file system. 

Yes, consider that 2 devices are identical in all respect.
ok lets discard the file (write, save) scenario after the resume. My doubt was, will I get the snapshot of file in RAM after I resume ?
Ok leave the file case.

Consider the case of few application (which is already present in both the devices) , 
lets say : In Device 1 we opened : Browser, calculator, a photo (already existing).
Then I captured the hibernated image in a swap file.
My I want to restore/resume this hibernated image from another _similar_ device.
After I resume, will I able to restore the same applications in Device 2 ????

Ok, if something cannot be resumed, we can throw it away.
I mean, during hibernation, if we opened 10 apps, and during resume we get only 5, that should be ok.
We can discard which ever is not relevant for Device 2.
 

> 
