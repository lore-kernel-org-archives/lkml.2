Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab0JIOdC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 10:33:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57580 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0JIOdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 10:33:00 -0400
MIME-Version: 1.0
In-Reply-To: <20101007175303.GB31639@kroah.com>
References: <1286447573-12579-1-git-send-email-roman.tereshonkov@nokia.com> <20101007175303.GB31639@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 9 Oct 2010 16:32:44 +0200
Message-ID: <AANLkTikmWqc6-jYWr5G7OdboA+TSgCM4qKVfJBNMjPZ=@mail.gmail.com>
Subject: Re: [PATCH] kobject: name reference should not be lost when lack of
 memory error happens
To: Greg KH <greg@kroah.com>
Cc: Roman Tereshonkov <roman.tereshonkov@nokia.com>,
        linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 19:53, Greg KH <greg@kroah.com> wrote:
> On Thu, Oct 07, 2010 at 01:32:53PM +0300, Roman Tereshonkov wrote:
>> If lack of memory error happens we must restore the old kobject name reference
>
> No, we can't do that, as the caller will not be expecting that to have
> happened, right Kay?
>
> I think the code as-is is correct, your kobject is in an unknown state
> and can't be used anymore.

Yeah, we've been there several times already with no clear decision so far.

Trying to set a kobject name twice seems like a serious bug.

We should kill the old_name logic, and add a WARN() when kobj->name is
already set when the function is called, I think.

People must use kobject_rename() if they want a new name, like the
comment above kobject_set_name() says.

Kay
