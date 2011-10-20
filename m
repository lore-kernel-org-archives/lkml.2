Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1JTNQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:16:35 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:55564 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752935Ab1JTNQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:16:34 -0400
Date: Thu, 20 Oct 2011 13:16:55 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: David Howells <dhowells@redhat.com>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, akpm@linux-foundation.org, oleg@redhat.com,
        richard@nod.at, mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        eparis@redhat.com, "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [PATCH 5/9] user namespace: clamp down users of cap_raised
Message-ID: <20111020131655.GA1700@hallyn.com>
References: <CALQRfL51U=cuLdVUpFXTog++3WwMjJB+9S6T8gVibC5gdGa5JQ@mail.gmail.com>
 <1318974898-21431-1-git-send-email-serge@hallyn.com>
 <1318974898-21431-6-git-send-email-serge@hallyn.com>
 <14652.1319014868@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14652.1319014868@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> 
> > #define NS_IS_NON_DEFAULT (current_user_ns() != &init_user_ns)
> 
> How about:
> 
> 	#define IN_ROOT_USER_NS (current_user_ns() == &init_user_ns)
> 
> And then:
> 
> 	if (!IN_ROOT_USER_NS() || !cap_raised(current_cap(), CAP_SYS_ADMIN)) {
> 
> I think it reads better.

My feeble brain does seem to process this faster.

I might make it !IN_INIT_USER_NS(), to be more consistent with
&init_user_ns.

Vasiliy had months ago suggested moving the whole idiom into its own
helper function.  Somehow I couldn't make the jump to this then...

thanks all,
-serge
