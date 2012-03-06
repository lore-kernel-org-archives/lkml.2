Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab2CFHu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:50:26 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:32860 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795Ab2CFHuZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 6 Mar 2012 02:50:25 -0500
Message-Id: <4F55CFCD02000078000768ED@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 06 Mar 2012 07:50:21 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Joe Perches" <joe@perches.com>
Cc: <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsprintf: make %pV handling compatible with
 kasprintf()
References: <4F54FCA402000078000766F1@nat28.tlf.novell.com>
 <1330966942.3140.8.camel@joe2Laptop>
In-Reply-To: <1330966942.3140.8.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.03.12 at 18:02, Joe Perches <joe@perches.com> wrote:
> On Mon, 2012-03-05 at 16:49 +0000, Jan Beulich wrote:
>> kasprintf() (and potentially other functions that I didn't run across
>> so far) want to evaluate argument lists twice. Caring to do so for the
>> primary list is obviously their job, but they can't reasonably be
>> expected to check the format string for instances of %pV, which however
>> need special handling too: On architectures like x86-64 (as opposed to
>> e.g. ix86), using the same argument list twice doesn't produce the
>> expected results, as an internally managed cursor gets updated during
>> the first run.
>> 
>> Fix the problem by always acting on a copy of the original list when
>> handling %pV.
> 
> Wouldn't stable need this too?

Possibly, but I'm not certain - this is more of a latent bug that I ran
into with some not yet submitted Xen code. And I'm not sure
whether latent bugs qualify for stable...

Jan

