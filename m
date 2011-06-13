Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1FMCzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 22:55:46 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:54196 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530Ab1FMCzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 22:55:44 -0400
X-AuditID: 12074424-b7bc6ae000005a77-52-4df57c2fc43e
Message-ID: <4DF57C29.4070601@mit.edu>
Date: Sun, 12 Jun 2011 22:55:37 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: "wanlong.gao" <wanlong.gao@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] efifb: Fix call to wrong unregister function
References: <1307875953.1859.6.camel@Tux>
In-Reply-To: <1307875953.1859.6.camel@Tux>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsUixCmqratf89XXYPUeeYsTfR9YLS7vmsNm
	8WrCa3aLroU32C3OHHnG6sDqsXPWXXaP9/uusnl83iQXwBzFZZOSmpNZllqkb5fAlfFzDU/B
	H7aKzvPf2RoYT7N2MXJwSAiYSFx9KNjFyAlkiklcuLeerYuRi0NIYB+jxLE7J1kgnA2MEq2z
	9jFCOG+ZJJ5efsYK0sIroCZxc85DMJtFQFXiwOnLjCA2m4CKRMfSB0wgtqhApcSknzug6gUl
	Ts58wgJi8wnISUzc+owZxBYR0JTYf/gKO8gCZoG5jBJTr60EaxAWcJQ4u3czO4gtBFT0e9U7
	sGZOAS2JL8eWgTUzC5hJdG3tYoSw5SW2v53DPIFRaBaSfbOQlM1CUraAkXkVo2xKbpVubmJm
	TnFqsm5xcmJeXmqRrrlebmaJXmpK6SZGUPizu6jsYGw+pHSIUYCDUYmHt/jKF18h1sSy4src
	Q4ySHExKorzyVV99hfiS8lMqMxKLM+KLSnNSiw8xSnAwK4nw9r4CKudNSaysSi3Kh0lJc7Ao
	ifPOk1T3FRJITyxJzU5NLUgtgsnKcHAoSfAGVQMNFSxKTU+tSMvMKUFIM3FwggznARruB1LD
	W1yQmFucmQ6RP8WoKCXOuwEkIQCSyCjNg+uFpadXjOJArwjzTgKp4gGmNrjuV0CDmYAGC5R+
	BhlckoiQkmpgXJWbIXJ+u6cJ7xE2xb6YZHHmLXUXBBzbXV9nqwdmRYiv79Y2nrEzf8/T+BXb
	7fle3j4mvFJk3trpx4V/74n41vexvH4+T1Wjckif3Bb/09P9PpR8X6cSLnb/wEM/56l3tQ2N
	sndtuqj855t0Y5Gw4pEYuX09H8VYruTz8/WfuVv0YfcL5954JZbijERDLeai4kQAJjM2KCoD
	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2011 06:52 AM, wanlong.gao wrote:
> <snip>
>
> Hi Maarten:
> It registered efifb_device but try to unregistered efifb_driver,
> so I think you should fix it like this?
>
> Signed-off-by: Wanlong Gao<wanlong.gao@gmail.com>
> ---
>   drivers/video/efifb.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
> index 69c49df..784139a 100644
> --- a/drivers/video/efifb.c
> +++ b/drivers/video/efifb.c
> @@ -541,7 +541,7 @@ static int __init efifb_init(void)
>   	 */
>   	ret = platform_driver_probe(&efifb_driver, efifb_probe);
>   	if (ret) {
> -		platform_device_unregister(&efifb_driver);
> +		platform_device_unregister(&efifb_device);
>   		return ret;
>   	}
>

Acked-by: Andy Lutomirski <luto@mit.edu>

That's my bug.  Sorry.  I'm not sure why it compiled, though.

--Andy
