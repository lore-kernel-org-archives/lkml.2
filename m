Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0JCBaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 21:30:09 -0400
Received: from web53706.mail.re2.yahoo.com ([206.190.37.27]:22082 "HELO
	web53706.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751118Ab0JCBaH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 21:30:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=1/ExOqsLlkR37RCanIKX5+91f7bDCJ7Un27JFkwTWLbI4C1gt3W5YgcaYs0ziTujb+CDPr1VbpH7v5eINBq13E+/tsAcou2Ts1XlAaMiyTMfEdsoYfuf9WDUTlyny0XTw8GGkV44OSKNvpExL5uY4FqCa3FUf4tcQen0DXbrYSU=;
Message-ID: <326156.76745.qm@web53706.mail.re2.yahoo.com>
X-YMail-OSG: hdxtGVAVM1n6PKoCTRTRnrlPFHo4TKoywcNd9faL0l2IPtS
 kRKgMh8f2T3MyL50H6HTxTcZmvh5LMDyDq5m_TMEPDqrcCnkuz4dOFJXB3R7
 B4ZcDh0t0VPsu1TYjK8PpDsja8Wx1CEcdvU9ClbpmePtsG53PPYS3G96V2hR
 VztIolJZ3kQJavd1_G_B5L8E1Ygpp6RgNR8tGCbDnJiZIVGTHCX87CYD_x.u
 oWHTHQkHXwdIfDNLJUl_LhKQGLgdV7kul2AgHql4yTw.ie6jSaCsFOIomYk3
 z.ztsIlo7rYvqKCGSH96mN4I7fQH5766zkU2FPAWUKOrd
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Sat, 2 Oct 2010 18:30:04 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 1/2] net: Fix the condition passed to sk_wait_event()
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,
     Thinking more about it, we need to check for sk->sk_err, thus the 
existing code behaves fine. Just that we might incur an additional sleep
even while we know that the socket already has an error, but that should
be ok.
We only need the other patch. Pls ignore this, and sorry for the confusion.

Thanks,
Tomar

--- On Sun, 3/10/10, Nagendra Tomar <tomer_iisc@yahoo.com> wrote:

> From: Nagendra Tomar <tomer_iisc@yahoo.com>
> Subject: [PATCH 1/2] net: Fix the condition passed to sk_wait_event()
> To: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
> Date: Sunday, 3 October, 2010, 5:19
> This patch fixes the sk_wait_event()
> condition in the sk_stream_wait_connect() 
> function. With this change, we correctly check for the
> TCPF_ESTABLISHED and 
> TCPF_CLOSE_WAIT states and avoid potentially returning
> success when there
> might be an error on the socket.
> 
> Signed-off-by: Nagendra Singh Tomar
> <tomer_iisc@xxxxxxxxx>
> ---
> --- linux-2.6.35.7/net/core/stream.c.orig   
> 2010-03-24 09:30:00.000000000 +0530
> +++ linux-2.6.35.7/net/core/stream.c   
> 2010-03-24 09:30:17.000000000 +0530
> @@ -73,9 +73,8 @@ int sk_stream_wait_connect(struct sock *
>         
> prepare_to_wait(sk_sleep(sk), &wait,
> TASK_INTERRUPTIBLE);
>         
> sk->sk_write_pending++;
>          done =
> sk_wait_event(sk, timeo_p,
> -           
>          !sk->sk_err
> &&
> -           
>          !((1 <<
> sk->sk_state) &
> -           
>        
>    ~(TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)));
> +           
>          ((1 <<
> sk->sk_state) &
> +           
>        
>    (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)));
>         
> finish_wait(sk_sleep(sk), &wait);
>         
> sk->sk_write_pending--;
>      } while (!done);
> 
> ---
> 
> 
> 
> 
> 



      
