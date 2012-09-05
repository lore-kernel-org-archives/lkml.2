Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858Ab2IEPbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:31:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48710 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2IEPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:31:35 -0400
Date: Wed, 5 Sep 2012 17:32:04 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "Shi, Yang A" <yang.a.shi@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "airlied@redhat.com" <airlied@redhat.com>
Subject: Re: [Patch 0/1]drm_irq: Introducing the irq_thread support
Message-ID: <20120905153204.GD5357@phenom.ffwll.local>
Mail-Followup-To: "Shi, Yang A" <yang.a.shi@intel.com>,
	"Liu, Chuansheng" <chuansheng.liu@intel.com>,
	"'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"alexander.deucher@amd.com" <alexander.deucher@amd.com>,
	"airlied@redhat.com" <airlied@redhat.com>
References: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com>
 <20120905132724.GC5357@phenom.ffwll.local>
 <E3ED5BF57CCD1C40876FA2D3385ED5D30FD781AC@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E3ED5BF57CCD1C40876FA2D3385ED5D30FD781AC@SHSMSX102.ccr.corp.intel.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 03:12:39PM +0000, Shi, Yang A wrote:
> Hi Vetter:
> 
>     Do you mean we can just not use drm_irq_install, and make
>     request_irq in our kernel driver pre-install or post-install
>     interface?

Well, you cant use the pre_install/post_install hooks the drm_irq code
provides, but yes, just do the request_irq in your driver code at the
right time, with the right parameters. Much easier than adding code to a
part of the drm core fraught with backwards-compat stuff no one really
wants to touch ... All the additional stuff besides calling request_irq
and the driver hooks that drm_irq_install does is really just to support
old dri1 userspace.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
