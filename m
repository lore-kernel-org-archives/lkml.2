Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1BTRZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 12:25:13 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:42570 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753866Ab1BTRZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 12:25:11 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Date: Mon, 21 Feb 2011 06:25:08 +1300
User-Agent: KMail/1.9.10
Cc: Ryan Mallon <ryan@bluewatersys.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <4D5DC368.2080003@bluewatersys.com> <20110218005852.GA14546@kroah.com>
In-Reply-To: <20110218005852.GA14546@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102210625.08616.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 February 2011 13:58:52 Greg KH wrote:
> On Fri, Feb 18, 2011 at 01:55:04PM +1300, Ryan Mallon wrote:
> > On 02/18/2011 01:43 PM, Mark Brown wrote:
> > > On Thu, Feb 17, 2011 at 04:33:53PM -0800, Greg KH wrote:
> > >> On Fri, Feb 18, 2011 at 12:01:50AM +0000, Mark Brown wrote:
> > >>> For the proc stuff - for tracing stuff then tracepoints are likely to
> > >>> be a good option if it's useful to people.
> > >>
> > >> Then use the in-kernel tracing functionality, don't roll your own. 
> > >> And that is not in /proc, so it should be there for this filesystem
> > >> either.
> > >
> > > That'd be the tracepoints I was mentioning, then...
> >
> > Are you suggesting that the yaffs_trace function should be replaced with
> > tracepoints?
> >
> > yaffs_trace is basically just a wrapper around printk, which I suggested
> > should be replaced with pr_debug so that it can be compiled out
> > completely. Other drivers and filesystems have similar custom debugging
> > functions.
> >
> > I haven't used tracepoints, but it seems like they are better suited to
> > tracing specific events than as a general printk style debugging
> > replacement?

The procfs is not used for tracing as , it is just one of the two ways 
ofsetting a trace mask to  select what to trace (the other is to set a trace 
mask).

eg.  echo +gc > /proc/yaffs

turns on the garbage collector tracing.

I will remove the /proc interface and write a userspace script to do the 
equivalent.

Realtime selection of tracing is valuable. It allows you to set up a test case 
with tracing disabled then select what you want to trace to get detail as you 
run the test case

I still intend to keep the tracing printk-based tracing:

#define yaffs_trace(msk, fmt, ...) do { \
	if (yaffs_trace_mask & (msk)) \
		printk(KERN_DEBUG "yaffs: " fmt "\n", ##__VA_ARGS__); \
} while (0)


> If you want printk(), then yes, use pr_debug() as it ties into the
> dynamic debug infrastructure, which is great.
>
> Then you can remove the proc files, as the kernel already controls the
> debug interface through the standard way, no need for a custom one.

Thanks.

I was not aware of pr_debug I shall investigate how it works.

-- CHarles


