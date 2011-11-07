Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab1KGQCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:02:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53302 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1KGQCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:02:14 -0500
Subject: Re: [PATCHv2 6/9] perf: expose perf capability to other modules.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Date: Mon, 07 Nov 2011 17:01:11 +0100
In-Reply-To: <20111107155336.GI8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
	 <1320323618-10375-7-git-send-email-gleb@redhat.com>
	 <1320674870.18053.37.camel@twins> <20111107155336.GI8670@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320681671.17809.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 17:53 +0200, Gleb Natapov wrote:
> I removed branch-miss-retired here because for perf user it exists. Perf
> approximates it by other event but perf user shouldn't know that. A
> guest is not always runs with exactly same cpu model number as a host,
> so if we will not drop the bit here if guest will see cpu model other
> than the one that has this quirk it will not be able to use the event.

Right, so what model number do you expose? Anyway I don't really mind
masking the thing as long as we grow an ebx iteration,

> BTW why perf does not check event mask to see if architectural event is
> available before programming it? 

No idea why not.. just one of those things nobody noticed/got around to
doing or so.
