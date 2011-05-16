Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1EPSCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:02:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59483 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1EPSCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=REPv19HOf8yXStPflxBNHCaQ7kNNmWHzF8LG5IbXz/giW12L0AB2wcYgXeLtnYCBYo
         WVKTWpEiTuWMULKsewtL8BcH7g4Z/vTHFrwA0B9WZTdVCcfTxcyU5ERhZtx2WhqEEIXt
         StpRnY7+9wqnPGHTmfRHzkpJaIODrZbmZGdwE=
MIME-Version: 1.0
In-Reply-To: <4DD14469.5030804@googlemail.com>
References: <1304455330-2728-1-git-send-email-abogani@kernel.org>
	<4DD14469.5030804@googlemail.com>
Date: Mon, 16 May 2011 14:02:09 -0400
Message-ID: <BANLkTi=2jW5PHB6QCaddHeZH0P=9PKWosw@mail.gmail.com>
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
From: Anders Kaseorg <andersk@ksplice.com>
To: Dirk Behme <dirk.behme@googlemail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 11:36, Dirk Behme <dirk.behme@googlemail.com> wrote:
> Then, thinking again, results in the question if the first argument of
> bsearch() shouldn't be 'name' rather than 'ks->name'?

Yes, it should be.

> Then it would be the job of cmp_name() to check for start == stop == 0?

Actually bsearch already handles this case correctly (it will make no
calls to cmp_name and return NULL), so nothing needs to specially
check for it.

Anders
