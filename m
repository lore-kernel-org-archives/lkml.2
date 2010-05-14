Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0ENFYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:24:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:7470 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab0ENFYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:24:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,226,1272870000"; 
   d="scan'208";a="621591559"
Date: Fri, 14 May 2010 13:19:45 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Haicheng Li <haicheng.li@linux.intel.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
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
Message-ID: <20100514051945.GA5438@shaohui>
Mail-Followup-To: Wu Fengguang <fengguang.wu@intel.com>,
	Haicheng Li <haicheng.li@linux.intel.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	"x86@kernel.org" <x86@kernel.org>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	David Rientjes <rientjes@google.com>, Alex Chiang <achiang@hp.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ak@linux.intel.co" <ak@linux.intel.co>,
	"shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>
References: <20100513114835.GD2169@shaohui>
 <4BECC418.2080602@linux.intel.com>
 <20100514041136.GA12020@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514041136.GA12020@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 12:11:36PM +0800, Wu Fengguang wrote:
> > Pls. replace it with following code:
> > 
> > +#ifdef CONFIG_NODE_HOTPLUG_EMU
> > +static ssize_t store_nodes_probe(struct sysdev_class *class,
> > +                                 struct sysdev_class_attribute *attr,
> > +                                 const char *buf, size_t count)
> > +{
> > +       long nid;
> > +       int ret;
> > +
> > +       ret = strict_strtol(buf, 0, &nid);
> > +       if (ret == -EINVAL)
> > +               return ret;
> > +
> > +       ret = hotadd_hidden_nodes(nid);
> > +       if (!ret)
> > +               return count;
> > +       else
> > +               return -EIO;
> > +}
> > +#endif
> 
> How about this?
> 
>        err = strict_strtol(buf, 0, &nid);
>        if (err < 0)
>                return err;
> 
>        err = hotadd_hidden_nodes(nid);
>        if (err < 0)
>                return err;
> 
>        return count;
> 
> Thanks,
> Fengguang

Both seems good.

Haicheng's code is prefered, since it was already reviewed.

-- 
Thanks & Regards,
Shaohui

