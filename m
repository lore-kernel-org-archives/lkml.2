Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2AaUJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 15:09:25 -0500
Received: from [206.117.179.246] ([206.117.179.246]:60213 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753832Ab2AaUJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 15:09:23 -0500
Message-ID: <1328040546.8012.6.camel@joe2Laptop>
Subject: Re: [PATCH] net: Disambiguate kernel message
From: Joe Perches <joe@perches.com>
To: Arun Sharma <asharma@fb.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Glauber Costa <glommer@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        christoph.paasch@uclouvain.be
Date: Tue, 31 Jan 2012 12:09:06 -0800
In-Reply-To: <20120131194718.GA9834@dev3310.snc6.facebook.com>
References: <1327963304-24828-1-git-send-email-asharma@fb.com>
	 <CAErSpo54KRJbWEQ0fB_kuGx0qRQKWpH9d3mN=dPdiNfWH+Dhww@mail.gmail.com>
	 <20120131181554.GA24397@dev3310.snc6.facebook.com>
	 <1328035857.6911.8.camel@joe2Laptop>
	 <20120131194718.GA9834@dev3310.snc6.facebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 11:47 -0800, Arun Sharma wrote:
> On Tue, Jan 31, 2012 at 10:50:57AM -0800, Joe Perches wrote:
> > It might be useful to use a generic routine.
[]
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
[]
> @@ -2014,11 +2014,14 @@ adjudge_to_death:
[]
> +		too_many_orphans = tcp_too_many_orphans(sk, 0);
> +		out_of_socket_memory = tcp_out_of_memory(sk);
> +		tcp_log_oom(too_many_orphans, out_of_socket_memory);
[]
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
[]
> @@ -77,10 +78,10 @@ static int tcp_out_of_resources(struct sock *sk, int do_reset)
[]
> +	too_many_orphans = tcp_too_many_orphans(sk, shift);
> +	out_of_socket_memory = tcp_out_of_memory(sk);
> +	tcp_log_oom(too_many_orphans, out_of_socket_memory);
> +	if (too_many_orphans || out_of_socket_memory) {

Perhaps these repeated three lines should be a routine like:

bool tcp_check_oom(struct sock *sk, int shift)
{
	bool tcp_orphans = tcp_too_many_orphans(sk, shift);
	bool tcp_oom = tcp_out_of_memory(sk);

	printks...

	return tcp_orphans || tcp_oom;
}

