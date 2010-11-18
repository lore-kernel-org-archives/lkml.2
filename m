Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0KRTdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:33:00 -0500
Received: from smtp-out-249.synserver.de ([212.40.180.249]:1038 "HELO
	smtp-out-247.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755384Ab0KRTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:32:58 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 5990
Date: Thu, 18 Nov 2010 20:32:55 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jamie Lokier <jamie@shareable.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, James Bottomley <James.Bottomley@suse.de>,
        Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        tytso@mit.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Message-ID: <20101118193255.GE1594@arch.trippelsdorf.de>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
 <20101118130630.GJ6178@parisc-linux.org>
 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org>
 <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site>
 <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
 <20101118180557.GU22787@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118180557.GU22787@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010.11.18 at 18:05 +0000, Jamie Lokier wrote:
> Jeff Moyer wrote:
> > James Bottomley <James.Bottomley@suse.de> writes:
> > 
> > > Not stepping into the debate: I'm happy to see punch go to the mapping
> > > data and FITRIM pick it up later.
> > >
> > > However, I think it's time to question whether we actually still want to
> > > allow online discard at all.  Most of the benchmarks show it to be a net
> > 
> > Define online discard, please.
> > 
> > > lose to almost everything (either SSD or Thinly Provisioned arrays), so
> > > it's become an "enable this to degrade performance" option with no
> > > upside.
> > 
> > Some SSDs very much require TRIMming to perform well as they age.  If
> > you're suggesting that we move from doing discards in journal commits to
> > a batched discard, like the one Lukas implemented, then I think that's
> > fine.  If we need to reintroduce the finer-grained discards due to some
> > hardware changes in the future, we can always do that.
> 
> "Growable" virtual disks benefit from it too, if it frees up a lot of space.
> 
> Windows has some ability to trim unused space in NTFS on virtual disks
> for this reason; I'm not sure if it's an online or offline procedure.
> 
> Online trim may be slow, but offline would be awfully inconvenient
> when an fs is big and needed for a live system, or when it's your root fs.

You can call FITRIM from a running system. Infact I run it once per week
as a cron job on my (mounted) root fs.

-- 
Markus
