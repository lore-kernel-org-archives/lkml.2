Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab0IXRHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:07:40 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:59980 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754496Ab0IXRHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:07:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SjcYWnZ21Ms1bhukQefwebYEEK3M1itDKivCCifnYJRdEklOd3e/oIlURsy9aHopivtNNLdzVGMLk6zVi9UePM00j69XgiXUYkig8UUWacehEuwuCd7WA52epeux2xpu;
Date: Fri, 24 Sep 2010 10:07:33 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 1/4] resources: ensure alignment callback doesn't
 allocate below available start
Message-ID: <20100924100733.2e7fa2ac@jbarnes-desktop>
In-Reply-To: <20100917223212.24687.3519.stgit@bob.kio>
References: <20100917223109.24687.17697.stgit@bob.kio>
	<20100917223212.24687.3519.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Sep 2010 16:32:12 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> The alignment callback returns a proposed location, which may have been
> adjusted to avoid ISA aliases or for other architecture-specific reasons.
> We already had a check ("tmp.start < tmp.end") to make sure the callback
> doesn't return a location above the available area.
> 
> This patch adds a check to make sure the callback doesn't return something
> *below* the available area, as may happen if the callback tries to allocate
> top-down.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---

Applied this series.  It's way bigger than I'd like at this point, but
it does fix some regressions, so I'll give Linus the option of pulling
it in my next pull request.  If he declines, we'll put it into -next
and tag it for inclusion into the stable series.

-- 
Jesse Barnes, Intel Open Source Technology Center
