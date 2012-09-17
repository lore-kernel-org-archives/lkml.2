Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab2IQSSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:18:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46615 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757121Ab2IQSSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:18:16 -0400
Date: Mon, 17 Sep 2012 22:18:10 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Al Viro <viro@zeniv.linux.org.uk>, Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 1/7] procfs: Add ability to plug in auxiliary fdinfo
 providers
Message-ID: <20120917181810.GH22360@moon>
References: <20120912212906.407242774@openvz.org>
 <20120912213507.272670512@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912213507.272670512@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 01:29:07AM +0400, Cyrill Gorcunov wrote:
> This patch brings ability to print out auxiliary data associated
> with file in procfs interface /proc/pid/fdinfo/fd.
> 
> In particular further patches make eventfd, evenpoll, signalfd
> and fsnotify to print additional information complete enough
> to restore these objects after checkpoint.
> 
> To simplify the code we add show_fdinfo callback inside
> struct file_operations (as Al and Pavel are proposing).
> 

Hi, sorry for bothering but is there some opinions on this series?

(I've found that epoll change log has not been well refreshed and
 says that this fdinfo feature is config-checkpoint-restore dependant,
 but in real this config entry was ripped off during conversation).

So, at moment I somehow confused since it's a bit unclear where to
move, either this series is more-less acceptible or not. I could
bring back all config-checkpoint-restore dependency (since I still
believe this feature better to be enabled not by default but iif
user has asked fo it).
