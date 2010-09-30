Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0I3HjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 03:39:09 -0400
Received: from mx7.orcon.net.nz ([219.88.242.57]:47746 "EHLO mx7.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab0I3HjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 03:39:05 -0400
Message-ID: <4CA43E95.5040301@orcon.net.nz>
Date: Thu, 30 Sep 2010 20:39:01 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
        mattst88@gmail.com, torvalds@linux-foundation.org,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/2] alpha: switch osf_sigprocmask() to use of sigprocmask()
References: <E1OzvxM-0002ng-B5@ZenIV.linux.org.uk> <4CA1B7DF.10202@orcon.net.nz> <20100929010738.GJ19804@ZenIV.linux.org.uk>
In-Reply-To: <20100929010738.GJ19804@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx7.orcon.net.nz on Thu, 30 Sep 2010 20:39:02 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Sep 30 20:39:03 2010
X-DSPAM-Confidence: 0.7617
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/10 14:07, Al Viro wrote:
> On Tue, Sep 28, 2010 at 10:39:43PM +1300, Michael Cree wrote:
>> On 27/09/10 07:28, Al Viro wrote:
>>>
>>> get rid of a useless wrapper, while we are at it
>>>
>>> Signed-off-by: Al Viro<viro@zeniv.linux.org.uk>
>>
>> Compiling this leads to the following errors:
 >
> Grrrr....   My apologies - cherry-pick from the wrong branch ;-/
>
> Al "nothing like seeing the errors one has fixed show up in what's sent" Viro

It appears to be worse than that.  It introduces a regression.  On boot 
up on a Compaq Alpha XP1000 the system appears to freeze at the point of 
mounting swap.  It eventually resumes after almost three minutes and 
continues to boot.  A bisection returned this very commit as the first 
bad commit.  With a kernel without this commit the (truncated) bootup 
log is:

[   19.904286] ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
[   20.133778] PCI: Setting latency timer of device 0000:01:00.1 to 64
[   20.900379] ieee1394: Host added: ID:BUS[0-00:1023] 
GUID[0000303c0009c6d0]
[   23.142566] hda-intel: azx_get_response timeout, switching to polling 
mode: last cmd=0x000f0001
[   24.162097] Adding 1999992k swap on /dev/sda2.  Priority:-1 extents:1 
across:1999992k
[   24.495104] EXT3-fs (sda4): using internal journal

With the commit the log becomes:

[   19.970692] ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
[   20.207020] PCI: Setting latency timer of device 0000:01:00.1 to 64
[   21.052723] ieee1394: Host added: ID:BUS[0-00:1023] 
GUID[0000303c0009c6d0]
[   23.215808] hda-intel: azx_get_response timeout, switching to polling 
mode: last cmd=0x000f0001
[  189.828027] Adding 1999992k swap on /dev/sda2.  Priority:-1 extents:1 
across:1999992k
[  190.162012] EXT3-fs (sda4): using internal journal

Otherwise the system seems to come up okay.

Cheers
Michael.
