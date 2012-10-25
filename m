Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab2JYKpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 06:45:38 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37722 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab2JYKpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 06:45:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=nET=Y+wdpOuBeuXj9gbVUOvg9NChLpbDrBS3QgMrn_Q@mail.gmail.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-6-git-send-email-hongbo.zhang@linaro.com>
	<CAKohpo=L-Xz90h90Q78gr7enOHK3u1TwHSs-QPQNE=0896SjRA@mail.gmail.com>
	<CAJLyvQxEAeP__drUAAz6D_UeeDRvdqKdmim3xAO7sXP8cCM8=g@mail.gmail.com>
	<CAKohpomZZiXnnkUC=9ZQoux1BVh+uJZw_oM1Ahndua2PZaKiDw@mail.gmail.com>
	<CAJLyvQw7=ucSTXH8YyPrm6LS8uDyxJkWGEVP2jQ3FL=cYN7frg@mail.gmail.com>
	<CAJLyvQzpo19hhwG9a4GEv0HCdJtfSJz_ASRnE-WKbwbMa58Akw@mail.gmail.com>
	<CAKohpo=grLyatiDEvSi_P+atRJ=JBVs_eWKbtumEkWenPr3EDg@mail.gmail.com>
	<CAKohpo=nET=Y+wdpOuBeuXj9gbVUOvg9NChLpbDrBS3QgMrn_Q@mail.gmail.com>
Date: Thu, 25 Oct 2012 18:45:35 +0800
Message-ID: <CAJLyvQyHuqaX1RMXV=wFcV9j1pkNTrbv7v-SjSmbweVn+BWxiQ@mail.gmail.com>
Subject: Re: [PATCH V2 5/6] Thermal: Add ST-Ericsson DB8500 thermal dirver.
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2012 18:11, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 25 October 2012 15:34, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 25 October 2012 15:26, Hongbo Zhang <hongbo.zhang@linaro.org> wrote:
>
> This is what your prcmu driver's routines are doing:
>
> int db8500_prcmu_config_hotmon(u8 low, u8 high)
> {
> ...
>         wait_for_completion(&mb4_transfer.work);
> ...
>         return 0;
> }
>
> This is why others in STE have used threaded_irqs... Because the
> routine you guys call from interrupt handlers actually sleeps.
>
I should find this for you, but you find it for me :(
Thanks a lot.
> So, they can't be called from interrupt context.
>
> I wanted you to knew this :)
>
> Its okay now, you need to use threaded irq only and you can't use
> normal request_irq(). Its not that you want to make things fast that's why
> you used threaded irqs... If you try to sleep from interrupt context
> (i.e. if you
> have registered your handler with request_irq()), you will see a kernel crash.
>
> --
> viresh
