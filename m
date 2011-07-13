Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376Ab1GMLtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:49:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965051Ab1GMLtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:49:45 -0400
Date: Wed, 13 Jul 2011 13:49:43 +0200
From: Michal Marek <mmarek@suse.cz>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nir Tzachar <nir.tzachar@gmail.com>,
        Andrej Gelenberg <andrej.gelenberg@udo.edu>
Subject: Re: [PATCH 2/2] kconfig/nconf: prevent segfault on empty menu
Message-ID: <20110713114943.GD25895@sepie.suse.cz>
References: <CACqU3MXvHR0v4Hgn5UMwDtzaX5nWqmKEneN_s7r4PuEGzifauw@mail.gmail.com>
 <1310282825-14509-1-git-send-email-lacombar@gmail.com>
 <1310282825-14509-2-git-send-email-lacombar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310282825-14509-2-git-send-email-lacombar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 03:27:05AM -0400, Arnaud Lacombe wrote:
> nconf does not check the validity of the current menu when help is requested
> (with either <F2>, '?' or 'h'). This leads to a NULL pointer dereference when an
> empty menu is encountered.
> 
> The following reduced testcase exposes the problem:
> 
> config DEP
>         bool
> 
> menu "FOO"
> 
> config BAR
>         bool "BAR"
>         depends on DEP
> 
> endmenu
> 
> Issue will happen when entering menu "FOO" and requesting help.
> 
> nconf is the only front-end which do not filter the validity of the current
> menu. Such filter can not really happen beforehand as other key which does not
> deals with the current menu might be entered by the user, so just bails out
> earlier if we encounter an invalid menu.
> 
> Cc: Nir Tzachar <nir.tzachar@gmail.com>
> Cc: Andrej Gelenberg <andrej.gelenberg@udo.edu>
> Reported-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>

Thanks, applied both patches to kbuild-2.6.git#kconfig.

Michal
