Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab0C3X17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:27:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28502 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab0C3X1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:27:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=xkLnoG1ZL7vpQEX/3tj70khLi+3SZbwp+3ma/0YLEIyAE7JKPAtwA9hI4lMJ53/3s
	b/ecxK3YYH7EkQoocTjBQ==
MIME-Version: 1.0
Date: Tue, 30 Mar 2010 16:27:49 -0700
Message-ID: <m2u5df78e1d1003301627ya1f621f7qaf0ad099f62d787e@mail.gmail.com>
Subject: lockup in rb_get_reader_page
From: Jiaying Zhang <jiayingz@google.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Michael Rubin <mrubin@google.com>,
       David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

We recently saw some cpu lockups while running kernel tracing.
The problem started to happen after we synced up our ring buffer
code with the upstream lockless ring buffer change. It usually
took many hours and heavy trace load to hit this problem. When
the lockup happens, the problematic cpu seemed to be in an infinite
loop of trying to grab the head_page in rb_get_reader_page().

We would like to check with you on whether this is a known issue.
If so, do we have a bug fix? If not, do you have any suggestions on
where we should check?

Thanks a lot!

Jiaying
