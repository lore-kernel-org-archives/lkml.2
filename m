Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab2B1IQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:16:06 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:31949 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab2B1IQE convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Tue, 28 Feb 2012 03:16:04 -0500
Message-Id: <4F4C9B7802000078000751BC@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 28 Feb 2012 08:16:40 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] consolidate WARN_...ONCE() static variables
References: <4F4BAAFA0200007800074F8F@nat28.tlf.novell.com>
 <20120227160302.ef9f6af4.akpm@linux-foundation.org>
 <4F4C93520200007800075197@nat28.tlf.novell.com>
 <20120227234451.3a00a76a.akpm@linux-foundation.org>
 <4F4C983002000078000751AE@nat28.tlf.novell.com>
 <20120228001210.26b59479.akpm@linux-foundation.org>
In-Reply-To: <20120228001210.26b59479.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.02.12 at 09:12, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 28 Feb 2012 08:02:40 +0000 "Jan Beulich" <JBeulich@suse.com> wrote:
> 
>> >>> On 28.02.12 at 08:44, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Tue, 28 Feb 2012 07:41:54 +0000 "Jan Beulich" <JBeulich@suse.com> wrote:
>> > 
>> >> >>> On 28.02.12 at 01:03, Andrew Morton <akpm@linux-foundation.org> wrote:
>> >> > On Mon, 27 Feb 2012 15:10:34 +0000
>> >> > "Jan Beulich" <JBeulich@suse.com> wrote:
>> >> > 
>> >> >> Due to the alignment of following variables, these typically consume
>> >> >> more than just the single byte that 'bool' requires, and as there are
>> >> >> a few hundred instances, the cache pollution (not so much the waste of
>> >> >> memory) sums up. Put these variables into their own section, outside
>> >> >> of any half way frequently used memory range.
>> >> >> 
>> >> >> v2: Do the same also to the __warned variable of rcu_lockdep_assert().
>> >> >> (Don't, however, include the ones used by printk_once() and alike, as
>> >> >> they can potentially be hot.)
>> >> > 
>> >> > I have a bad feeling that I still don't understand this patch.  Ho hum.
>> >> > 
>> >> > What are the rules for the new .data.unlikely section?  When should
>> >> > people put variables into this section?  Perhaps we can document this
>> >> > somewhere?
>> >> 
>> >> If I knew the "where" part of this, I could put together a few sentences.
>> >> I just grep-ed through Documentation/, without finding e.g. any rules
>> >> or guidelines for using {,un}likely()...
>> >>
>> > 
>> > At the definition site in vmlinux.lds?
>> 
>> Sorry, Andrew, but this makes no sense to me.
> 
> I really don't care - anywhere you like.  Just the darn changelog, if
> nowhere else.
> 
> I still don't have an answer to my question :( Some statement
> describing what the new section is *for*.  Seems a pretty important
> thing?

Oh, sorry - to carry static data the accesses to which are unlikely
(i.e., as in the case given, fully contained in code sections inside
conditionals which themselves use unlikely() on their primary/only
clause - in other words, something that the compiler really could
do on its own).

Jan

