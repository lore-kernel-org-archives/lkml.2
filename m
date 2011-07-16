Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab1GPS1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 14:27:30 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38630
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab1GPS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 14:27:26 -0400
Date: Sat, 16 Jul 2011 14:27:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: KY Srinivasan <kys@microsoft.com>, Christoph Hellwig <hch@infradead.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 097/117] Staging: hv: storvsc: Add code to handle IDE
 devices using the storvsc driver
Message-ID: <20110716182723.GA21943@infradead.org>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-97-git-send-email-kys@microsoft.com>
 <20110716020447.GB7199@infradead.org>
 <6E21E5352C11B742B20C142EB499E0480817A4DA@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <1310821299.1976.2.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310821299.1976.2.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 04:01:39PM +0300, Sasha Levin wrote:
> Is think that what Christoph meant was simplifying it to:
> 
> 	if (dev_is_ide)
> 		storvsc_get_ide_info(device, &target, &path);
> 	
> 	host_dev->path = device_info.path_id;
> 	host_dev->target = device_info.target_id;

Indeed.  In addition path is unused and target is only used in the
second dev_is_ide conditional, so both the call and the target and path
variables can be moved into that one to further simplify the function.

But I'm fine with delaying that cleanup to a follow on patch so that
we can make progress in getting this pile merged.

