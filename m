Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1BGSFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:05:33 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:42462 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab1BGSFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:05:32 -0500
X-Greylist: delayed 1177 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Feb 2011 13:05:32 EST
Date: Mon, 7 Feb 2011 13:05:24 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A lot of [ext4-dio-unwrit] threads around
Message-ID: <20110207180524.GD3457@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>,
	linux-kernel@vger.kernel.org
References: <4D502746.4030500@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D502746.4030500@pardus.org.tr>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 07:09:26PM +0200, Ozan Çağlayan wrote:
> 
> This is 2.6.35.11 on a 24-core HP Proliant server with 8 mounted
> ext4 filesystems. There are 7 LXC containers which does heavy
> compiling workload during the day.
> 
> Uptime is 3 days and currently there are 216 ext4-dio-unwrit threads
> in ps aux output? Is it normal or a symptom of a problem?

It's normal; the workqueues are created statically at mount time, one
per cpu per file system.  There are some plans in train for a more
efficient way of dealing with workqueues in general on systems with
large numbers of CPU's, but for 2.6.35, yes, that's normal.

      	      	 	    		- Ted
