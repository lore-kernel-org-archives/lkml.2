Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1H2RZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:25:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab1H2RZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:25:29 -0400
Date: Mon, 29 Aug 2011 19:21:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 3/4] freezer: check freezing() before
	leaving FROZEN state
Message-ID: <20110829172132.GA12191@redhat.com>
References: <20110829140418.GB18871@mtj.dyndns.org> <20110829140509.GC18871@mtj.dyndns.org> <20110829140549.GD18871@mtj.dyndns.org> <20110829163533.GB9973@redhat.com> <20110829171228.GA11339@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829171228.GA11339@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29, Oleg Nesterov wrote:
>
> Hmm. But I got lost a bit. Why do we need freezer_lock to set/clear
> PF_FROZEN ? OK, the code below takes freezer_lock for freezing().
> Is there any other reason?

Ah, at least we need it to serialize with __thaw_task() which does
"if (frozen) wake_up()".

Oleg.

