Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2LSWEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:04:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43137 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab2LSWEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:04:47 -0500
Date: Wed, 19 Dec 2012 23:04:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v6 03/27] x86, boot: move verify_cpu.S and no_longmode
 after 0x200
Message-ID: <20121219220443.GJ24895@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <1355436141-8668-4-git-send-email-yinghai@kernel.org>
 <20121215170625.GA9875@liondog.tnic>
 <CAE9FiQUSoSvtFMMQt3eZkrXFCkzXhLu6GfqYMGNb3=uA052Axw@mail.gmail.com>
 <20121219205732.GI24895@liondog.tnic>
 <CAE9FiQXOV-GZk6HR17KcDsiPM89=eNHdYRSP2A6n5R_AKnhaLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQXOV-GZk6HR17KcDsiPM89=eNHdYRSP2A6n5R_AKnhaLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 01:58:57PM -0800, Yinghai Lu wrote:
> On Wed, Dec 19, 2012 at 12:57 PM, Borislav Petkov <bp@alien8.de> wrote:
> > On Tue, Dec 18, 2012 at 07:44:55PM -0800, Yinghai Lu wrote:
> >
> > So this explains what you're doing but I'd like to know why?
> >
> > Why do you need to free some more room between startup_32 and
> > startup_64? Do you need this room in another patch, maybe the next one:
> >
> > "[PATCH v7 14/27] x86, boot: Move lldt/ltr out of 64bit code section"
> >
> > Is that so? If yes, please write that in the commit message so that we
> > know why you're doing that change.
> 
> duplicate next patch commit log here. no, that's too long.

Sorry, I'm not suggesting to duplicate the patch commit log here -
simply say instead:

"We are short of space before address 0x200 which is the 64-bit entry
point (startup_64). Since we're going to need that space in the next
patch, and, according to hpa, startup_64 has become an ABI and thus
cannot be moved, move function verify_cpu and no_longmode further down."

See, clear and simple.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
