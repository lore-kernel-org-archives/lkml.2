Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab2APFnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 00:43:33 -0500
Received: from hades.mikemestnik.net ([184.106.158.151]:33910 "EHLO
	hades.mikemestnik.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2APFnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 00:43:32 -0500
Message-ID: <4F13B902.1090503@mikemestnik.net>
Date: Sun, 15 Jan 2012 23:43:30 -0600
From: Mike Mestnik <cheako@mikemestnik.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0) Gecko/20111223 Thunderbird/10.0
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Chronic resource starvation.
References: <4F10F3AE.3030801@mikemestnik.net>  <4F11E3B8.6090007@mikemestnik.net>  <1326629295.6352.14.camel@marge.simson.net>  <4F1322A6.7090009@mikemestnik.net> <1326681574.6446.25.camel@marge.simson.net>
In-Reply-To: <1326681574.6446.25.camel@marge.simson.net>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/12 20:39, Mike Galbraith wrote:
> On Sun, 2012-01-15 at 13:01 -0600, Mike Mestnik wrote:
>> On 01/15/12 06:08, Mike Galbraith wrote:
>>>> Does this behavior look normal or is it just my system?  If it is normal
>>>> how difficult would it be to make corrections and would those
>>>> corrections likely be kernel or application related?
>>> That "Backup complete" makes me suspect a classic case of IO-itis.  If
>>> bits of your GUI were pushed out or ram (or weren't previously used),
>>> and live on a disk you're beating hell out of, you get to experience
>>> horrid interactivity while those missing bits are being retrieved.
>> Thank you for the reply!
>>
>> That's DVDShrink, copies from optical drive(slow) to disk(fast-ish?).
>> http://www.dvdshrink.info/
>>
>> That wouldn't explain why the monitor(gkrellm) stopped updating, every
>> part of that is pooling like top would.  Gkrellm indicates disk activity
>> and it shows the backup complete on sr1 and a backup in progress on sr0,
>> however neither of these operations rate on Disk or sda.
> No, dvdshrink wouldn't do enough IO to matter much.  Heavy IO can (or
> could) cause symptoms like your video though, all of it.  I used to be
> able to trigger loss of GUI control for 30 minutes at a time.  All it
> took was something poking fdatasync after a large streaming IO had been
> running for a while.
Ahhh, as I had suspected I'm not the only one.

Does fdatasync still cause this problem?  I'm sure there must be
some way to 'group' applications together that should be allowed to
avoid this effect and even insert IO requests during the operation if
given a high enough priority.
>
> Another IO thing that can cause horrible interactivity is IO error
> recovery.  That can (or again, could) make a box lurch like hell.  If
> that were the cause, you'd have kernel gripes in dmesg output.
Sure, this happens as a 'feature' of commercial DVDs and some times on
accident:

[5636213.987232] sr 4:0:0:0: [sr0] Device not ready
[5636213.987235] sr 4:0:0:0: [sr0]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[5636213.987238] sr 4:0:0:0: [sr0]  Sense Key : Not Ready [current]
[5636213.987240] sr 4:0:0:0: [sr0]  Add. Sense: Medium not present -
tray closed
[5636213.987243] sr 4:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00
00 08 00
[5636213.987248] end_request: I/O error, dev sr0, sector 0
[5636213.987251] Buffer I/O error on device sr0, logical block 0
[5636213.987253] Buffer I/O error on device sr0, logical block 1
[5636213.987260] Buffer I/O error on device sr0, logical block 2
[5636213.987261] Buffer I/O error on device sr0, logical block 3
[5636213.987263] Buffer I/O error on device sr0, logical block 4
[5636213.987265] Buffer I/O error on device sr0, logical block 5
[5636213.987266] Buffer I/O error on device sr0, logical block 6
[5636213.987267] Buffer I/O error on device sr0, logical block 7
[5636213.997003] sr 4:0:0:0: [sr0] Device not ready
[5636213.997005] sr 4:0:0:0: [sr0]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[5636213.997007] sr 4:0:0:0: [sr0]  Sense Key : Not Ready [current]
[5636213.997010] sr 4:0:0:0: [sr0]  Add. Sense: Medium not present -
tray closed
[5636213.997012] sr 4:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00
00 02 00
[5636213.997016] end_request: I/O error, dev sr0, sector 0
[5636213.997018] Buffer I/O error on device sr0, logical block 0


> 	-Mike
>

