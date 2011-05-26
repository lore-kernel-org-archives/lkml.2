Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839Ab1EZEdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 00:33:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab1EZEdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 00:33:44 -0400
Date: Thu, 26 May 2011 00:33:38 -0400
From: Dave Jones <davej@redhat.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: no sound in current -git
Message-ID: <20110526043337.GA11224@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Takashi Iwai <tiwai@suse.de>
References: <20110526013423.GA25226@redhat.com>
 <4DDDD47C.5030504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DDDD47C.5030504@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 09:18:04PM -0700, Justin P. Mattock wrote:
 > On 05/25/2011 06:34 PM, Dave Jones wrote:
 > > Since the last ALSA merge, I have no sound on my laptop.
 > > I have onboard intel sound, and a NuForce µDAC. Neither of them show up
 > > in alsamixer, or pavucontrol.
 > 
 > sound over here is out as well on a macbook pro. seems gnome shell 
 > didn't like whats being merged with the current Mainline i.g. no sound 
 > bluetooth applet missing. will bisect when I get a chance.

Maybe it was this that just got merged..  (building now)

commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5
Author: Eric Paris <eparis@redhat.com>
Date:   Wed May 25 19:49:18 2011 -0700

    tmpfs: fix XATTR N overriding POSIX_ACL Y
    
    Choosing TMPFS_XATTR default N was switching off TMPFS_POSIX_ACL,
    even if it had been Y in oldconfig; and Linus reports that PulseAudio
    goes subtly wrong unless it can use ACLs on /dev/shm.
    
    Make TMPFS_POSIX_ACL select TMPFS_XATTR (and depend upon TMPFS),
    and move the TMPFS_POSIX_ACL entry before the TMPFS_XATTR entry,
    to avoid asking unnecessary questions then ignoring their answers.
    
    Signed-off-by: Hugh Dickins <hughd@google.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

