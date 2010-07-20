Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761490Ab0GTT1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:27:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64519 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761443Ab0GTT1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=avt1fbBXbxOxCWuMf2TMuGBhG5p3qcqcYHmY8FWODuOISlO7WfFFAIo4JeHPfGWbDx
         3URYbl3DMpcoa9VdJeJ5M7YWPRdYQ3Yq0W6dWLRo2Y+FbjWSwGnngnOYVUVsdCJACcw6
         z/Ghov1YK1ARoS3D19m2F9ewAF39JiDyLc4Zo=
Date: Tue, 20 Jul 2010 23:27:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
Message-ID: <20100720192717.GC6227@lenovo>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 08:50:47PM +0200, Robert Richter wrote:
>
> This patch series contains some cleanups and reworks I made during
> code review and feature implementation for upcoming cpus.
> 
> Most patches refactor the xsave initialization that is very dependent
> on fpu initialization. This series starts to decouple this a little
> bit as xsave not only supports fpu features. Also this is an attempt
> to ease the xsave interface by making some of the functions and
> variables static.
> 
> There is also one patch that removes boot_cpu_id variable, which is
> not really related to xsave. Maybe this should be applied to another
> branch.
> 
> The patches are relative to today's tip/x86/xsave branch.
> 
> (The patches are small for better review and rebasing.)
> 
> -Robert
> 

Hi Robert, I recall there was a thread related to boot_cpu_id and
cpu = 0. Unfortunately I can't find it neither in my mbox nor somewhere
in net at moment. Ie technically speaking -- yes boot_cpu_id will be 0
but perhaps instead of magic !cpu and friends explicit boot_cpu_id might
be better for code reading. It might be is_boot_cpu() macro helper or
so as well.

Though I don't have strong opinion but for ones who will be
reading the code first time it might be confusing :) Agreed?

	-- Cyrill
