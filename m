Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab0LMStq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:49:46 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:46526 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab0LMStp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:49:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=U69v+43PHfnt4L2LusKcEhKtdvPGJkg41qUFDoW7z9mOCTvjt6F1wK92JIv74bFL2A
         XVCh9dGV1WIgF1zLthsehLBctFnDPJCu6Fmn+3IABlzNF0Z281Vs0PPchzGAN3VA18Z5
         QeiA0Q7tvOZy5E/+t4KMmVY7ZngBTcGCN/nGQ=
MIME-Version: 1.0
In-Reply-To: <1292263974-15363-1-git-send-email-toralf.foerster@gmx.de>
References: <1292263974-15363-1-git-send-email-toralf.foerster@gmx.de>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 13 Dec 2010 19:49:43 +0100
Message-ID: <AANLkTi=oHyk3AF3eKP3Vm2Ywfb9WcgrurNrkYVKfc588@mail.gmail.com>
Subject: Re: [PATCH] checkpatch.pl: ERROR: spaces required
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/13 Toralf Förster <toralf.foerster@gmx.de>:
>
> Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
> ---
>  kernel/acct.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/acct.c b/kernel/acct.c
> index fa7eb3d..9ca7be8 100644
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -144,7 +144,7 @@ static int check_free_space(struct bsd_acct_struct *acct, struct file *file)
>        spin_lock(&acct_lock);
>        if (file != acct->file) {
>                if (act)
> -                       res = act>0;
> +                       res = act > 0;
>                goto out;
>        }
>
> @@ -396,7 +396,7 @@ static comp_t encode_comp_t(unsigned long value)
>        return exp;
>  }
>
> -#if ACCT_VERSION==1 || ACCT_VERSION==2
> +#if ACCT_VERSION == 1 || ACCT_VERSION == 2
>  /*
>  * encode an u64 into a comp2_t (24 bits)
>  *
> @@ -440,7 +440,7 @@ static comp2_t encode_comp2_t(u64 value)
>  }
>  #endif
>
> -#if ACCT_VERSION==3
> +#if ACCT_VERSION == 3
>  /*
>  * encode an u64 into a 32 bit IEEE float
>  */
> @@ -449,8 +449,8 @@ static u32 encode_float(u64 value)
>        unsigned exp = 190;
>        unsigned u;
>
> -       if (value==0) return 0;
> -       while ((s64)value > 0){
> +       if (value == 0) return 0;

Newline here. Doesn't checkpatch.pl complain? It is an old rule:

http://lxr.linux.no/linux+v2.6.36/Documentation/CodingStyle#L60

> +       while ((s64)value > 0) {
>                value <<= 1;
>                exp--;
>        }
> @@ -510,13 +510,13 @@ static void do_acct_process(struct bsd_acct_struct *acct,
>                       + current->group_leader->start_time.tv_nsec;
>        /* convert nsec -> AHZ */
>        elapsed = nsec_to_AHZ(run_time);
> -#if ACCT_VERSION==3
> +#if ACCT_VERSION == 3
>        ac.ac_etime = encode_float(elapsed);
>  #else
>        ac.ac_etime = encode_comp_t(elapsed < (unsigned long) -1l ?
>                               (unsigned long) elapsed : (unsigned long) -1l);
>  #endif
> -#if ACCT_VERSION==1 || ACCT_VERSION==2
> +#if ACCT_VERSION == 1 || ACCT_VERSION == 2
>        {
>                /* new enlarged etime field */
>                comp2_t etime = encode_comp2_t(elapsed);
> @@ -529,15 +529,15 @@ static void do_acct_process(struct bsd_acct_struct *acct,
>        /* we really need to bite the bullet and change layout */
>        ac.ac_uid = orig_cred->uid;
>        ac.ac_gid = orig_cred->gid;
> -#if ACCT_VERSION==2
> +#if ACCT_VERSION == 2
>        ac.ac_ahz = AHZ;
>  #endif
> -#if ACCT_VERSION==1 || ACCT_VERSION==2
> +#if ACCT_VERSION == 1 || ACCT_VERSION == 2
>        /* backward-compatible 16 bit fields */
>        ac.ac_uid16 = ac.ac_uid;
>        ac.ac_gid16 = ac.ac_gid;
>  #endif
> -#if ACCT_VERSION==3
> +#if ACCT_VERSION == 3
>        ac.ac_pid = task_tgid_nr_ns(current, ns);
>        rcu_read_lock();
>        ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent), ns);
> --
> 1.7.2.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
