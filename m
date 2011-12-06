Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1LFVay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:30:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab1LFVaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:30:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Layton <jlayton@redhat.com>
Subject: Re: CIFS mount: 3.2.0-rc3 suspend crash
Date: Tue, 6 Dec 2011 22:33:50 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Belisko Marek <marek.belisko@gmail.com>,
        linux-cifs@vger.kernel.org
References: <4ED56C12.1040708@gmail.com> <4ED5C047.6040500@linux.vnet.ibm.com> <20111130062502.68d9db59@tlielax.poochiereds.net>
In-Reply-To: <20111130062502.68d9db59@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112062233.50317.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 30, 2011, Jeff Layton wrote:
> On Wed, 30 Nov 2011 11:03:59 +0530
> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:

[...]
> 
> cifs: attempt to freeze while looping on a receive attempt
> 
> In the recent overhaul of the demultiplex thread receive path, we
> neglected to ensure that we attempt to freeze on each pass through the
> loop.
> 
> Reported-by: Woody Suwalski <terraluna977@gmail.com>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

I suppose this patch is going to go through the CIFS tree?

Rafael


> ---
>  fs/cifs/connect.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index bf82f88..d166e3a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -441,6 +441,8 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
>  	smb_msg.msg_controllen = 0;
>  
>  	for (total_read = 0; to_read; total_read += length, to_read -= length) {
> +		try_to_freeze();
> +
>  		if (server_unresponsive(server)) {
>  			total_read = -EAGAIN;
>  			break;
> 

