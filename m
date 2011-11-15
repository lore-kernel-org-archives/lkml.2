Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1KOT1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:27:23 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44661 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab1KOT1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:27:19 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Suresh Jayaraman'" <sjayaraman@suse.com>
Cc: <linux-kernel@vger.kernel.org>, <ap@solarrain.com>,
        "'linux-cifs'" <linux-cifs@vger.kernel.org>
References: <00c001cca300$4b512b80$e1f38280$@lucidpixels.com> <4EC269FC.1060104@suse.com>
In-Reply-To: <4EC269FC.1060104@suse.com>
Subject: RE: kernel 3.1.1 - cifs issue - ls: cannot access /cifs_mnt: Cannot allocate memory
Date: Tue, 15 Nov 2011 14:27:11 -0500
Message-ID: <004b01cca3cc$932e4240$b98ac6c0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQLZrMe+81ABFycPwSqDEaFeFY6RxgEseDgwk4rbqFA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Suresh Jayaraman [mailto:sjayaraman@suse.com] 
Sent: Tuesday, November 15, 2011 8:33 AM
To: Justin Piszcz
Cc: linux-kernel@vger.kernel.org; ap@solarrain.com; linux-cifs
Subject: Re: kernel 3.1.1 - cifs issue - ls: cannot access /cifs_mnt: Cannot
allocate memory

[Cc linux-cifs@vger.kernel.org]

On 11/15/2011 12:34 AM, Justin Piszcz wrote:
> Hi,
> 
> CIFS "works" when I mount a Windows 7 host from my Linux host
(3.1.1-x86_64)
> but if I turn my machine off (Windows) and turn it back on, I get the
> following error, is this normal? With NFS as a hardmount it just recovers,
> with CIFS do I need to setup some sort of canary to unmount/remount?
> 
>  $ ls /cifs_mnt
> ls: cannot access /cifs_mnt: Cannot allocate memory
> 

This looks like a problem specific to Windows 7 or above. Quick tests on
my test machines shows that cifs attempts to connect, times out,
attempts to reconnect and gets -EHOSTUNREACH in case of both Windows
Servers and Samba Servers. This is the expected behavior.

OTOH, this sounds like a problem related to an error due to the Windows
server being unable to allocate from the system nonpaged pool (seen in
the past). Do you see anything that is related to the error in Windows
Event viewer?

Hi,

Yes, you are correct--

The server was unable to allocate from the system nonpaged pool because the
server reached the configured limit for nonpaged pool allocations.

Justin.

