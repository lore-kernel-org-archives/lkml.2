Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0KFTGa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:06:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45866 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0KFTG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:06:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZnB2f5k8MD1N78jjW20S5aBnrj97Sa88dUGZdMse8zjjOlRIETVSwv2ZIvrvfhQWdy
         vmQwcDEyG+BpHiMb7hCgb88kjeOHlbL41+t9Xo9q+RwJ0RhnVUJeVSWcedx7TFrIH319
         UqrGlEZRz2DtC7IX9Fw9U2aPs7d4PAAeq6QIU=
MIME-Version: 1.0
In-Reply-To: <1289067954-5080-6-git-send-email-rabin@rab.in>
References: <1289067954-5080-1-git-send-email-rabin@rab.in>
	<1289067954-5080-6-git-send-email-rabin@rab.in>
Date: Sat, 6 Nov 2010 19:06:28 +0000
Message-ID: <AANLkTin8UO9ixVep0jKK8H5roWEVRDJW4khUpT2TpPs+@mail.gmail.com>
Subject: Re: [PATCH 6/6] ARM: ftrace: enable function graph tracer
From: Catalin Marinas <catalin.marinas@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 6, 2010, Rabin Vincent <rabin@rab.in> wrote:
> Add the options to enable the function graph tracer on ARM.  Function
> graph tracer support requires frame pointers, so exclude Thumb-2 and
> also explicitly select FRAME_POINTER in FUNCTION_GRAPH_TRACER since
> FUNCTION_TRACER doesn't select FRAME_POINTER when ARM_UNWIND is used
> Therefore, with GCC 4.4.0+, you get plain function tracing without frame
> pointers, but you'll need them if you want function graph tracing.
.....
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -141,6 +141,7 @@ config FUNCTION_TRACER
>
>  config FUNCTION_GRAPH_TRACER
>         bool "Kernel Function Graph Tracer"
> +       select FRAME_POINTER if ARM_UNWIND

Would it be better to modify FRAME_POINTER definition in the ARM
Kconfig so that it is enabled automatically when FUNCTION_GRAPH_TRACER
is enabled?

-- 
Catalin
