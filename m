Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2LELQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:16:18 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40384 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab2LELQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:16:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAA7rmPF0NNxRQr0N7FgP=7NW7iy77HhEy46_T74kTcAdB6rvSg@mail.gmail.com>
References: <1354620834-2953-1-git-send-email-xtfeng@gmail.com>
	<20121204155434.GE3885@mtj.dyndns.org>
	<CAA7rmPF0NNxRQr0N7FgP=7NW7iy77HhEy46_T74kTcAdB6rvSg@mail.gmail.com>
Date: Wed, 5 Dec 2012 12:16:12 +0100
Message-ID: <CAA7rmPHEcA0n=_Hhuhzk7LpwigUJ7WGota2en5KNQTb4hnthww@mail.gmail.com>
Subject: Re: [PATCH 1/2] megaraid: fix BUG_ON() from incorrect use of delayed work
From: Daniel Vacek <neelx.g@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Xiaotian Feng <xtfeng@gmail.com>, linux-kernel@vger.kernel.org,
        Xiaotian Feng <dannyfeng@tencent.com>,
        Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 12:02 PM, Daniel Vacek <neelx.g@gmail.com> wrote:
> On Tue, Dec 4, 2012 at 4:54 PM, Tejun Heo <tj@kernel.org> wrote:
>> @@ -5190,7 +5188,7 @@ static void
>>  megasas_aen_polling(struct work_struct *work)
>>  {
>>         struct megasas_aen_event *ev =
>> -               container_of(work, struct megasas_aen_event, hotplug_work);
>> +               container_of(work, struct megasas_aen_event, hotplug_work.work);
>>         struct megasas_instance *instance = ev->instance;
>>         union megasas_evt_class_locale class_locale;
>>         struct  Scsi_Host *host;
>
> -megasas_aen_polling(struct work_struct *work)
> +megasas_aen_polling(struct delayed_work *work)
>
> Not really sure. Just asking?

Never mind, it's ok. Now I get it. Sorry for the buzz.

--nX
