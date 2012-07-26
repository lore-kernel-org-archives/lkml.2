Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2GZVeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:34:09 -0400
Received: from smtp.syd.comcen.com.au ([203.23.236.77]:1763 "EHLO
	smtp.syd.comcen.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab2GZVeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:34:03 -0400
Message-ID: <5011B7B3.3040907@spin.net.au>
Date: Fri, 27 Jul 2012 07:33:39 +1000
From: Chris Jones <chrisjones@spin.net.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120604 Firefox/13.0 SeaMonkey/2.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] NTFS code doesn't sanitize folder names sufficiently
References: <501189DA.4030709@enkore.de>
In-Reply-To: <501189DA.4030709@enkore.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-comcen-MailScanner-Information: Please contact the ISP for more information
X-comcen-MailScanner: Found to be clean
X-comcen-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.244, required 4, AWL 0.26, BAYES_00 -2.60, RDNS_NONE 0.10)
X-comcen-MailScanner-From: chrisjones@spin.net.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marian Beermann wrote:
> Hello everyone,
>
> today I noticed some very odd behaviour, which could lead people to 
> believe a loss of data, because it is possible to create directories 
> with backslashes in them.
>
> I am currently running kernel 3.5.
>
> To completly reproduce the problem to the full extend you'll need a 
> Windows computer, but to see whats wrong Linux completly suffices :-)
>
> On a Linux computer
> 1. Create a directory named TestA on an NTFS partition
> 2. Create a subdirectory of TestA named TestB
> 3. Create a third directory alongside TestA named TestA\TestB (the 
> fundamental problem is this: backslashes in directory names)
>
> Connect the drive containing the NTFS partition now to a Windows 
> computer and navigate to the directory containing TestA and 
> TestA\TestB. If you navigate to the folder (not path!) TestA\TestB 
> you'll actually see the contents of the path TestA\TestB (the 
> subfolder TestB) and not the contents of the directory.
> It is not possible on a Windows machine to access the contents of the 
> directory named TestA\TestB. This is not a bug in Windows, it's caused 
> by a bug in the NTFS driver, which allows illegal characters.
>
> The solution to this would be to disallow creation of files and 
> folders on NTFS drives containing illegal characters.
>
> Best regards
> Marian Beermann

Yeah that's a tough one. I wouldn't exactly call it a bug. There's 
probably lots of stuff like this you could do that the command line 
would allow you to perform but not be a correct and intended function. I 
would put this down to user error rather than a bug. Anyone with 
knowledge of operating systems and file system structuring should know 
that / or \ are illegal characters for creating a directories. Whether 
it be on Windows or Linux.


Regards

-- 
		Chris Jones @ kernel.devproject@gmail.com
also on oracle.kerneldev@gmail.com and netbsd.kerneldev@gmail.com

OpenSUSE 12.1 (IceWM/zsh) (PC)|Android 4.0.3 (Smartphone)|Windows 7 (Laptop)|Windows XP (Gaming)
Linux kernel developer|Solaris kernel developer|BSD kernel developer
Lead Developer of SDL|Lead Developer of Nest Linux|Gamer and Emulator nut|Web Services|Digital Imaging Services
Controllers: Rapier V2 Gaming mouse|Logitech Precision|PS3 controller|XB360 controller|Logitech Attack 3 j/stick
Emulators: Fusion|Gens|ZSNES|Project64|PCSX-R|Stella|WinVICE|WinUAE|DOSBox

PGP Fingerprint: 4E38 0776 B380 63C8 F64F
A7D6 736C CF56 42A4 FB35

