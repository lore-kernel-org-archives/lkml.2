Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab2EGWNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 18:13:36 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65004 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756640Ab2EGWNe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 18:13:34 -0400
MIME-Version: 1.0
In-Reply-To: <4FA8195E.2010706@am.sony.com>
References: <4FA4673C.7010209@am.sony.com>
	<20120504233707.GA24213@kroah.com>
	<4FA8195E.2010706@am.sony.com>
Date: Mon, 7 May 2012 15:13:33 -0700
Message-ID: <CANqkERCQixuCe9vfeDncHikED-bVwZ3APr=mo6WfQBcGf4rz_g@mail.gmail.com>
Subject: Re: [PATCH] staging: android: logger: Allocate logs dynamically at boot
From: Brian Swetland <swetland@google.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 11:50 AM, Tim Bird <tim.bird@am.sony.com> wrote:
> On 05/04/2012 04:37 PM, Greg KH wrote:
>> On Fri, May 04, 2012 at 04:33:16PM -0700, Tim Bird wrote:
>>> +#define MAX_LOGS    5
>>> +struct logger_log *logs_array[MAX_LOGS];
>>
>> You are going to make this a list and not a static array in the
>> future, right?
>
> Would that be better?  The for-loop is IMHO simpler than a
> list walk for finding matches.  I anticipate that the size of
> this array should never (famous last words) be bigger than about
> 20 entries, even in the dynamic-allocation-per-application
> case.  And that's a ways off in implementation.
>
> I'll be happy to switch to a linked list once it looks like we're
> going to have more than 5 entries.  Or I can switch to a linked
> list now if you think it's better form to code for the longer-term
> anticipated features.
>
> Not a big deal to me either way.

I'd also favor a list approach. It won't break unexpectedly when
somebody inevitably adds that 6th log or whatever, and the list
traversal cost only occurs during open(), which is not a frequent
operation -- most users keep the log driver open for the process
lifespan (both readers and writers).

Brian
