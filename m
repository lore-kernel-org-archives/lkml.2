Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1KUIIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 03:08:35 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:44295 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1KUIId convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:2>);
	Mon, 21 Nov 2011 03:08:33 -0500
Message-Id: <4ECA150C0200007800062072@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 21 Nov 2011 08:08:28 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Kevin Cernekee" <cernekee@gmail.com>,
        "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] module: Fix performance regression on
 modules with large symbol tables
References: <4EC0E4040200007800060B1C@nat28.tlf.novell.com>
 <63fcc782681c8b3bd330164871ad4785@localhost>
 <87ipme9i9o.fsf@rustcorp.com.au>
In-Reply-To: <87ipme9i9o.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.11.11 at 06:06, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thu, 17 Nov 2011 19:15:02 -0800, Kevin Cernekee <cernekee@gmail.com> wrote:
>> Potential memory savings from reusing EXACT strtab matches: 36,475 bytes
>> total; 35,432 from nvidia.ko.  For comparison, discarding non-core
>> strtab entries saved about 91KB on my system.
> ...
>> Original scheme: 1.230s
>> With patch V2: 0.280s
>> With naive copying: 0.058s
> 
> I'm deeply tempted.  It's very simple, 46 lines shorter, preserves exact
> matches, and doesn't have any strange slowdowns on corner cases.
> 
> But like Kevin, I could be convinced either way.  Jan?

I'd be fine with the simpler solution, as long it is clearly understood
(and marked as intended to be that was for the time being) that it
has room for improvement, should it ever turn out to yield more
significant savings in other contexts.

Jan

