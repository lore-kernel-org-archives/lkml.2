Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab1KONeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 08:34:22 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:24137 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab1KONeU (ORCPT
	<rfc822;groupwise-SJayaraman@suse.com:0:0>);
	Tue, 15 Nov 2011 08:34:20 -0500
Message-ID: <4EC269FC.1060104@suse.com>
Date: Tue, 15 Nov 2011 19:02:44 +0530
From: Suresh Jayaraman <sjayaraman@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, ap@solarrain.com,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: kernel 3.1.1 - cifs issue - ls: cannot access /cifs_mnt: Cannot
 allocate memory
References: <00c001cca300$4b512b80$e1f38280$@lucidpixels.com>
In-Reply-To: <00c001cca300$4b512b80$e1f38280$@lucidpixels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc linux-cifs@vger.kernel.org]

On 11/15/2011 12:34 AM, Justin Piszcz wrote:
> Hi,
> 
> CIFS "works" when I mount a Windows 7 host from my Linux host (3.1.1-x86_64)
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


-Suresh
