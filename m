Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2JUKDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 06:03:33 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63342 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2JUKDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 06:03:31 -0400
Message-ID: <5083C8E4.7090007@gmail.com>
Date: Sun, 21 Oct 2012 12:05:24 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
CC: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org,
        amit.kachhap@linaro.org
Subject: Re: [PATCH 1/5] Thermal: do bind operation after thermal zone or
 cooling device register returns.
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com> <1350387889-15324-2-git-send-email-hongbo.zhang@linaro.com>
In-Reply-To: <1350387889-15324-2-git-send-email-hongbo.zhang@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/16/2012 01:44 PM, hongbo.zhang wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
> 
> In the previous bind function, cdev->get_max_state(cdev, &max_state) is called
> before the registration function finishes, but at this moment, the parameter
> cdev at thermal driver layer isn't ready--it will get ready only after its
> registration, so the the get_max_state callback cannot tell the max_state
> according to the cdev input.
> This problem can be fixed by separating the bind operation out of registration
> and doing it when registration completely finished.

When thermal_cooling_device_register() is called, the thermal framework
assumes the cooling device is "ready", i.e. all of its ops callbacks
return meaningful results. If the cooling device is not ready at this
point, then this is a bug in the code that registers it.
Specifically, the faulty code in your case is in the cpufreq cooling
implementation, where the cooling device is registered before being
added to the internal list of cpufreq cooling devices. So, IMHO the fix
is needed there.

--
Francesco
