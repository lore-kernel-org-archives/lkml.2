Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2EJXRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:17:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780Ab2EJXRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:17:15 -0400
Message-ID: <4FAC4C6B.7030307@redhat.com>
Date: Thu, 10 May 2012 20:16:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
References: <1336679788-4982-1-git-send-email-mchehab@redhat.com>  <20120510204042.GA4598@aftab.osrc.amd.com> <4FAC2B3E.8000105@redhat.com> <1336690016.14207.240.camel@gandalf.stny.rr.com>
In-Reply-To: <1336690016.14207.240.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 10-05-2012 19:46, Steven Rostedt escreveu:
> On Thu, 2012-05-10 at 17:55 -0300, Mauro Carvalho Chehab wrote:
> 
>>>>  EXPORT_SYMBOL_GPL(edac_mc_handle_error);
>>>> diff --git a/include/ras/hw_event.h b/include/ras/hw_event.h
>>>> new file mode 100644
>>>> index 0000000..66981ef
>>>> --- /dev/null
>>>> +++ b/include/ras/hw_event.h
>>>> @@ -0,0 +1,77 @@
>>>> +#undef TRACE_SYSTEM
>>>> +#define TRACE_SYSTEM hw_event
>>>
>>> 			ras
>>
>> Then, the header name should be called as "ras.h", otherwise an error happens:
>>
>> In file included from include/ras/hw_event.h:77:0,
>>                  from drivers/edac/edac_mc.c:38:
>> include/trace/define_trace.h:79:43: fatal error: ../../include/ras/ras.h: Arquivo ou diretório não encontrado
> 
> From samples/trace_events/trace-events-sample.h:
> 
> /*
>  * TRACE_INCLUDE_FILE is not needed if the filename and TRACE_SYSTEM are equal
>  */
> #define TRACE_INCLUDE_FILE trace-events-sample
> 
> Thus, you could do:
> 
> +++ b/include/ras/hw_event.h
> 
> +undef TRACE_SYSTEM
> +define TRACE_SYSTEM ras
> 
> [...]
> 
> #define TRACE_INCLUDE_FILE hw_event
> 
> 
> -- Steve

Thanks, Steve!

I'll rename it to include/ras/ras_event.h

Regards,
Mauro
