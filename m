Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2JVKOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 06:14:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47114 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab2JVKOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 06:14:44 -0400
Date: Mon, 22 Oct 2012 12:14:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Borislav Petkov <bp@amd64.org>, tony.luck@intel.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, miaox@cn.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in
 cmci_rediscover().
Message-ID: <20121022101442.GB8352@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tang Chen <tangchen@cn.fujitsu.com>, Borislav Petkov <bp@amd64.org>,
	tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com,
	hpa@zytor.com, miaox@cn.fujitsu.com, laijs@cn.fujitsu.com,
	wency@cn.fujitsu.com, x86@kernel.org, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
 <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com>
 <20121019164045.GE11958@aftab.osrc.amd.com>
 <5084AB10.7010807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5084AB10.7010807@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 10:10:24AM +0800, Tang Chen wrote:
> I don't why before we just jumped over it. But I think if we have an
> online cpu == dying here, it must be wrong. So I think we should warn
> it, not just jump over it.

Why do we need to warn? What good would that bring us?

AFAICT, the check in cmci_rediscover is there to make sure we absolutely
don't rediscover on the dying cpu. I think it is a safety precaution in
concurrency scenarios between cpu hotplug and mce code.

Thanks.

-- 
Regards/Gruss,
    Boris.
