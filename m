Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665Ab2BBX5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:57:17 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49202 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933643Ab2BBX5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:57:13 -0500
X-Sasl-enc: uJZJ6EnUt5fqbTmRy5HBFL/j9Wf0cklQr5obQICWGxsT 1328227031
Date: Thu, 2 Feb 2012 15:48:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 3/6] drivers: hv: Cleanup the kvp related state in
 hyperv.h
Message-ID: <20120202234848.GA26647@kroah.com>
References: <1327708522-26914-1-git-send-email-kys@microsoft.com>
 <1327708562-26964-1-git-send-email-kys@microsoft.com>
 <1327708562-26964-3-git-send-email-kys@microsoft.com>
 <20120202232936.GA9614@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481B70927D@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B70927D@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 11:41:29PM +0000, KY Srinivasan wrote:
> > > +#ifndef __packed
> > > +#define __packed __attribute__((packed))
> > > +#endif
> > 
> > Why do this?
> > 
> > If you are so worried about this in userspace, then just change the
> > values below to __attribute__((packed)), like all of the other public .h
> > files do.
> 
> Greg,
> 
> When I ran the checkpatch script against these patches I got a warning that the
> preferred directive was to use "__packed".

Well, checkpatch is stupid sometimes.

> So, for the header file that will be
> consumed in the kernel, I chose to go with the __packed. For inclusion of this
> header file in the user space daemon, I put in this definition here. So rather
> than having numerous warnings, I now have a single warning. If you prefer,
> I can move this definition to the daemon code where it is really needed.

Please do it like all other public kernel header files do.

greg k-h
