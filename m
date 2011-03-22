Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1CVBFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 21:05:34 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38256 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab1CVBFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 21:05:31 -0400
Message-ID: <4D87F5E6.3010208@cs.wisc.edu>
Date: Mon, 21 Mar 2011 20:05:42 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Jesper Juhl <jj@chaosbits.net>
Subject: Re: [RFC-v4 07/12] iscsi-target: Add CHAP Authentication support
 using libcrypto
References: <1300613497-2091-1-git-send-email-nab@linux-iscsi.org> <1300613497-2091-8-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1300613497-2091-8-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2011 04:31 AM, Nicholas A. Bellinger wrote:
> +static struct iscsi_chap *chap_server_open(
> +	struct iscsi_conn *conn,
> +	struct iscsi_node_auth *auth,
> +	const char *A_str,
> +	char *AIC_str,
> +	unsigned int *AIC_len)

Lot of mixed cases like this and below in the patch.



> +
> +static int chap_server_compute_md5(
> +	struct iscsi_conn *conn,
> +	struct iscsi_node_auth *auth,
> +	char *NR_in_ptr,
> +	char *NR_out_ptr,
> +	unsigned int *NR_out_len)



> +	return 2;
> +}
> diff --git a/drivers/target/iscsi/iscsi_target_auth.h b/drivers/target/iscsi/iscsi_target_auth.h
> new file mode 100644
> index 0000000..17b042d
> --- /dev/null
> +++ b/drivers/target/iscsi/iscsi_target_auth.h



> +
> +struct iscsi_chap {
> +	unsigned char	digest_type;
> +	unsigned char	id;
> +	unsigned char	challenge[CHAP_CHALLENGE_LENGTH];
> +	unsigned int	challenge_len;
> +	unsigned int	authenticate_target;
> +	unsigned int	chap_state;
> +} ____cacheline_aligned;
> +

Why are almost all structs in the patches ____cacheline_aligned? Is it 
something we are just doing now, or does this affect performance somehow 
even though the struct is not used in a perf path?
