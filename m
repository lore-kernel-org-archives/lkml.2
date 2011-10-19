Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab1JSJC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 05:02:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab1JSJCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 05:02:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CALQRfL51U=cuLdVUpFXTog++3WwMjJB+9S6T8gVibC5gdGa5JQ@mail.gmail.com>
References: <CALQRfL51U=cuLdVUpFXTog++3WwMjJB+9S6T8gVibC5gdGa5JQ@mail.gmail.com> <1318974898-21431-1-git-send-email-serge@hallyn.com> <1318974898-21431-6-git-send-email-serge@hallyn.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: dhowells@redhat.com, Serge Hallyn <serge@hallyn.com>,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        akpm@linux-foundation.org, oleg@redhat.com, richard@nod.at,
        mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        eparis@redhat.com, "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [PATCH 5/9] user namespace: clamp down users of cap_raised
Date: Wed, 19 Oct 2011 10:01:08 +0100
Message-ID: <14652.1319014868@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> #define NS_IS_NON_DEFAULT (current_user_ns() != &init_user_ns)

How about:

	#define IN_ROOT_USER_NS (current_user_ns() == &init_user_ns)

And then:

	if (!IN_ROOT_USER_NS() || !cap_raised(current_cap(), CAP_SYS_ADMIN)) {

I think it reads better.

David
