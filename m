Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab2HPUAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 16:00:39 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45107 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab2HPUAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 16:00:33 -0400
Date: Thu, 16 Aug 2012 16:00:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List" 
	<linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: ext4fs error "ext4_mb_generate_buddy:741:group 16, 8160 clusters
 in bitmap, 4064 in gd" (with repro)
Message-ID: <20120816200032.GE31346@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List" <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <50238A29.3060808@redhat.com>
 <20120809170640.GA6607@thunk.org>
 <alpine.LFD.2.00.1208151116530.4904@dhcp-1-248.brq.redhat.com>
 <alpine.LFD.2.00.1208161619440.2459@vpn-8-20.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1208161619440.2459@vpn-8-20.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 04:28:07PM +0200, Lukáš Czerner wrote:
> 
> After a little bit of tracing with the systemtap and blktrace ext4
> does not seem to be doing anything wrong and yet we get part of the
> block bitmap trimmed. This lead me to the scsi_debug driver itself
> and indeed it seems that we have off-by-one bug there in the
> unamp_region() which is causing the problem.

Thanks for finding this --- I was getting scared that ext4 users were
losing data in production.  It's good to know it was just a bug in the
scsi_debug driver.

						- Ted
