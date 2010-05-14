Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0ENFwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:52:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:18635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab0ENFwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:52:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,227,1272870000"; 
   d="scan'208";a="798362815"
Date: Fri, 14 May 2010 13:52:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Rientjes <rientjes@google.com>, Alex Chiang <achiang@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.co" <ak@linux.intel.co>,
       "shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>
Subject: Re: [RFC, 3/7] NUMA hotplug emulator
Message-ID: <20100514055236.GA29036@localhost>
References: <20100513114835.GD2169@shaohui>
 <4BECC418.2080602@linux.intel.com>
 <20100514041136.GA12020@localhost>
 <4BECE052.5020907@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BECE052.5020907@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 01:32:02PM +0800, Haicheng Li wrote:
> Wu Fengguang wrote:
> >> Pls. replace it with following code:
> >>
> >> +#ifdef CONFIG_NODE_HOTPLUG_EMU
> >> +static ssize_t store_nodes_probe(struct sysdev_class *class,
> >> +                                 struct sysdev_class_attribute *attr,
> >> +                                 const char *buf, size_t count)
> >> +{
> >> +       long nid;
> >> +       int ret;
> >> +
> >> +       ret = strict_strtol(buf, 0, &nid);
> >> +       if (ret == -EINVAL)
> >> +               return ret;
> >> +
> >> +       ret = hotadd_hidden_nodes(nid);
> >> +       if (!ret)
> >> +               return count;
> >> +       else
> >> +               return -EIO;
> >> +}
> >> +#endif
> > 
> > How about this?
> > 
> >        err = strict_strtol(buf, 0, &nid);
> >        if (err < 0)
> >                return err;
> 
> other negative value would be odd here.

Yes, strict_strtoul() will be better.

> >        err = hotadd_hidden_nodes(nid);
> >        if (err < 0)
> >                return err;
> 
> hotadd_hidden_nodes could return -EEXIST, which is also odd here, right?

Why not? write(2) says "Other errors may occur, depending on the
object connected to fd."

Thanks,
Fengguang
