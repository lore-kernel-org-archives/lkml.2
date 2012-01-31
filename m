Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2AaUqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 15:46:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49937 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710Ab2AaUqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 15:46:49 -0500
Message-ID: <4F285310.5060104@fb.com>
Date: Tue, 31 Jan 2012 12:46:08 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Glauber Costa <glommer@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        <christoph.paasch@uclouvain.be>
Subject: Re: [PATCH] net: Disambiguate kernel message
References: <1327963304-24828-1-git-send-email-asharma@fb.com>  <CAErSpo54KRJbWEQ0fB_kuGx0qRQKWpH9d3mN=dPdiNfWH+Dhww@mail.gmail.com>  <20120131181554.GA24397@dev3310.snc6.facebook.com>  <1328035857.6911.8.camel@joe2Laptop>  <20120131194718.GA9834@dev3310.snc6.facebook.com> <1328040546.8012.6.camel@joe2Laptop>
In-Reply-To: <1328040546.8012.6.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-31_07:2012-01-31,2012-01-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/12 12:09 PM, Joe Perches wrote:

>> +	too_many_orphans = tcp_too_many_orphans(sk, shift);
>> +	out_of_socket_memory = tcp_out_of_memory(sk);
>> +	tcp_log_oom(too_many_orphans, out_of_socket_memory);
>> +	if (too_many_orphans || out_of_socket_memory) {
>
> Perhaps these repeated three lines should be a routine like:
>
> bool tcp_check_oom(struct sock *sk, int shift)
> {
> 	bool tcp_orphans = tcp_too_many_orphans(sk, shift);
> 	bool tcp_oom = tcp_out_of_memory(sk);
>
> 	printks...
>
> 	return tcp_orphans || tcp_oom;
> }

I like your previous suggestion better. It preserves the ability to write:

if (too_many_orphans) {
   do_something();
}

if (out_of_socket_memory) {
   do_something_else();
}

  -Arun


