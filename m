Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab1HNJUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 05:20:44 -0400
Received: from mother.openwall.net ([195.42.179.200]:46465 "HELO
	mother.openwall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751253Ab1HNJUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 05:20:41 -0400
Date: Sun, 14 Aug 2011 13:20:28 +0400
From: Solar Designer <solar@openwall.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
Message-ID: <20110814092028.GB14293@openwall.com>
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org> <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 10:08:57PM -0700, H. Peter Anvin wrote:
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> >Sounds to me a better alternative would be more aggressive, pro-active
> >fuzzing of the compat calls.
[...]
> Agreed.  Other than that, I can see a fine-grained permission filter, but the compat vs noncompat axis is just spurious.

In case anyone cares, I respectfully disagree.  I am with Vasiliy on
this.  I think that proactive fuzzing is great, but it is not an
alternative - we can also do both fuzzing and reduction of attack
surface at once.  With Vasiliy reusing an existing check (in a future
revision of the patch), there's not going to be any performance impact.
Fine-grained restrictions would be great, but the 32- vs. 64-bit
restriction makes sense to me as well.  I expect different systems to
use these different kinds of restrictions in different cases.

We will definitely want to support x32 as well.  We'd appreciate any
suggestions on how to do it best.

Thanks,

Alexander
