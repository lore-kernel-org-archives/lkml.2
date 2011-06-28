Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab1F1MbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:31:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47384 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab1F1Ma5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 08:30:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110628082512.GA3386@htj.dyndns.org>
References: <201106262108.43011.vda.linux@googlemail.com> <20110626200442.GA16293@redhat.com>
 <20110627081139.GY30101@htj.dyndns.org> <20110627134713.GB3527@redhat.com>
 <20110627135252.GB30101@htj.dyndns.org> <20110627151827.GA6223@redhat.com> <20110628082512.GA3386@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 28 Jun 2011 14:30:36 +0200
Message-ID: <BANLkTik2KqKGwBAqN+CSz7_ergx5VM9x4A@mail.gmail.com>
Subject: Re: [PATCH] ptrace: make former thread ID available via
 PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.2)
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 10:25 AM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Jun 27, 2011 at 05:18:27PM +0200, Oleg Nesterov wrote:
>> > and the only way to discover would be either comparing kernel
>> > version or actually trying it - both aren't too nice.
>>
>> Fortunately, currently tracehook_report_exec() zeroes ->ptrace_message.
>> At least this means that anything != 0 means it works.
>
> Yeah, but that's a pretty silly way to do it.  If we make it depend on
> PT_SEIZED, we can simply say "if seized, EXEC reports..." but as it
> currently stands, it would go like "If the message is non-zero on
> EXEC, it indicates...  This behavior is valid since kernel version
> x.x.x".

This is true for any new addition to API.
It starts from some kernel version.

> Maybe adding a guarantee that PTRACE_SEIZE capable kernel
> always reports the old pid on EXEC but that would still seem
> unnecessarily complicated.  It isn't a bug fix.  I don't see much
> point in introducing new behavior separately.

This new feature looks orthogonal to PTRACE_SEIZE to me.

-- 
vda
