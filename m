Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab1FAAqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:46:20 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50539 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955Ab1FAAqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:46:19 -0400
X-Nat-Received: from [202.181.97.72]:58224 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1306889171.7683
Message-Id: <201106010046.p510kBaM004304@www262.sakura.ne.jp>
Subject: Re: [PATCH] AppArmor: fix oops in apparmor_setprocattr
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Jun 2011 09:46:11 +0900
References: <20110531183141.GH19633@outflux.net> <alpine.LRH.2.00.1106011024150.16178@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1106011024150.16178@tundra.namei.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 31052011 #5451850, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> Is this trigger able by unprivileged users?

Anybody who can call .setprocattr LSM hook can trigger this bug, but for most
configurations BUG_ON() will prevent NULL pointer dereference.

179 int aa_audit(int type, struct aa_profile *profile, gfp_t gfp,
180              struct common_audit_data *sa,
181              void (*cb) (struct audit_buffer *, void *))
182 {
183         BUG_ON(!profile);
 
> From which upstream commit is this an issue?

Since 2.6.36.
