Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1HPTjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:39:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab1HPTjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:39:13 -0400
Date: Tue, 16 Aug 2011 21:36:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: Re: [PATCH 39/41] dlm: Remove another superfluous call to
	recalc_sigpending()
Message-ID: <20110816193623.GA6411@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-40-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-40-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Matt Fleming wrote:
>
> recalc_sigpending() is called within sigprocmask(), so there is no
> need call it again after sigprocmask() has returned.

And more, this is simply wrong. This can race with signal_wake_up().

ACK. but may me you can update the changelog although I won't insist.

Oleg.

