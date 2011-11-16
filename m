Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1KPPmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:42:22 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55764 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab1KPPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:42:20 -0500
MIME-Version: 1.0
In-Reply-To: <004126aa92b5c1e0d1b464409510fd5dd9771523.1321442150.git.viresh.kumar@st.com>
References: <cover.1321442150.git.viresh.kumar@st.com> <004126aa92b5c1e0d1b464409510fd5dd9771523.1321442150.git.viresh.kumar@st.com>
From: Rabin Vincent <rabin@rab.in>
Date: Wed, 16 Nov 2011 21:05:02 +0530
X-Google-Sender-Auth: awz1HpeJzcaf4C1uei7Gz0BfeZI
Message-ID: <CAH+eYFA=S6Jk-dar4bsiogA2sJii0Q5Akuf3eoa9TRpLPe3G9Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] mfd/stmpe: Pass partnum as param to stmpe_probe()
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com, bhavna.yadav@st.com, vincenzo.frascino@st.com,
        mirko.gardi@st.com, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 16:56, Viresh Kumar <viresh.kumar@st.com> wrote:
> partnum is required during probe to get variant's info. Currently partnum was
> getting set in i2c interface after it is used and is not at all getting set in
> spi interface.

So your previous patch is broken?  Please fix it and resend it instead
since it's not merged yet.

>
> This can be passed as param to stmpe_probe, so that it is available early. With
> this, there is no need of i2c interface's init() routine, as it does nothing
> else than calling dev_set_drvdata(). So better remove this routine for i2c.
>
> partnum defined in struct stmpe is of no use now, as it is only used once during
> probe of stmpe, so we can remove it from struct stmpe too.

Not quite; it's used from drivers/input/keyboard/stmpe-keypad.c.  Please
preserve this stmpe->partnum, drop your 2/5 patch which exposes variant
externally, and instead use stmpe->partnum in 5/5.
