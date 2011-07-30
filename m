Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab1G3WdC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:33:02 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41976 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1G3Wc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:32:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x=kqa0GxRH9o=8faPhuyyLcqxH8+AOowBTK_gMaDgJyeVA@mail.gmail.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<e2c1bd6941e88f8988b1942c13c20cf436b3a963.1311936524.git.viresh.kumar@st.com>
	<1311941355.1536.529.camel@vkoul-udesk3>
	<CAOh2x=kqa0GxRH9o=8faPhuyyLcqxH8+AOowBTK_gMaDgJyeVA@mail.gmail.com>
Date: Sun, 31 Jul 2011 00:32:55 +0200
X-Google-Sender-Auth: tcjHlptdNijapw3f2283I9vFduA
Message-ID: <CAKnu2MrWbm5w6QsBzj=Fd=f7SfE=4_7bHMBBdQiN2bCnbeV-eg@mail.gmail.com>
Subject: Re: [PATCH 04/18] dmaengine/amba-pl08x: Remove redundant comment and
 rewrite original
From: Linus Walleij <linus.walleij@linaro.org>
To: viresh kumar <viresh.linux@gmail.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>, linux@arm.linux.org.uk,
        pratyush.anand@st.com, rajeev-dlh.kumar@st.com, bhupesh.sharma@st.com,
        armando.visconti@st.com, linux-kernel@vger.kernel.org,
        vipin.kumar@st.com, shiraz.hashim@st.com, amit.virdi@st.com,
        vipulkumar.samar@st.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/29 viresh kumar <viresh.linux@gmail.com>:
> On 7/29/11, Koul, Vinod <vinod.koul@intel.com> wrote:
>> On Fri, 2011-07-29 at 16:19 +0530, Viresh Kumar wrote:
>>>  /*
>>> - * Autoselect a master bus to use for the transfer this prefers the
>>> - * destination bus if both available if fixed address on one bus the
>>> - * other will be chosen
>>> + * Autoselect a master bus to use for the transfer
>>> + * - prefers the destination bus if both available
>>> + * - if fixed address on one bus the other will be chosen
>> Not sure I get it, English is not my first language :)
>
> Nor mine either. :)
>
> Will give some more explanation.
>
> But before that i wanted to know the exact purpose of this
> master-slave concept here.

The PL08x has two bus mastering interfaces. They can be
connected to two separate busses and two adress spaces
even, usually that is not the case though.

> Probably it is for choosing the victim for reduction of width, in case
> src and dest addresses
> are misaligned to each other.
> @Russell and Linus: Is this correct?

You can see from the function that it is only about choosing the
master and slave. One of them is reading from some memory
and one of them is writing. These are called source and
destination respectively.

What it then does is:

- If one of the buses will be targeting a fixed
  address, choose the other one, so the one that increase address
  become master and the fixed address slave
.
- If both buses increas address (usually memory-to-memory) the
  third case is activated and deals with trying to set the widest
  bus as master.

Crystal clear?

Please copyedit/author something like the above...

Thanks,
Linus Walleij
