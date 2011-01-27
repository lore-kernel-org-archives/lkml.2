Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1A0KHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:07:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57069 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1A0KHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:07:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U2pxyLtaIbpyHRcd7a6KNBRZww/+MWaeMWnEajrSTZ4JzRWkagBBmHm74ye54tnCuZ
         NVd1ufAZRBYvHMbtsjoW81FHxltgnLTh6ooZnug1jwX7DIX3vq0HOLTcIc6XBpMiSiG5
         u76pvn/awenK0/nMDXLaMIclE5hKwJgg4fB24=
MIME-Version: 1.0
In-Reply-To: <1295993854-4971-13-git-send-email-arnd@arndb.de>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
	<1295993854-4971-13-git-send-email-arnd@arndb.de>
Date: Thu, 27 Jan 2011 21:07:44 +1100
Message-ID: <AANLkTim=d4Tok-ri1BozZUfBFS=rofaodN8ZBA5AjKKd@mail.gmail.com>
Subject: Re: [PATCH 12/20] x25: remove the BKL
From: Andrew Hendry <andrew.hendry@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Left it running and put about 3.0G through x.25, it was running fine
until after about 20 hours.
I was stopping the test programs and hit this.

Jan 27 20:18:34 jaunty kernel: [80403.945790] PGD 1d8b00067 PUD 1ddec3067 PMD 0
Jan 27 20:18:34 jaunty kernel: [80403.945836] CPU 3
Jan 27 20:18:34 jaunty kernel: [80403.945842] Modules linked in: x25
nls_cp437 cifs binfmt_misc kvm_intel kvm snd_hda_codec_via
snd_usb_audio snd_hda_intel snd_hda_codec nouveau snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_hwdep snd_usbmidi_lib
snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
psmouse snd_timer snd_seq_device serio_raw fbcon ttm tileblit font
bitblit softcursor xhci_hcd drm_kms_helper snd drm asus_atk0110
soundcore snd_page_alloc i2c_algo_bit video usbhid hid usb_storage
r8169 pata_jmicron ahci mii libahci
Jan 27 20:18:34 jaunty kernel: [80403.946026]
Jan 27 20:18:34 jaunty kernel: [80403.946034] Pid: 28187, comm:
x25echotest Not tainted 2.6.38-rc2+ #41 P7P55D-E PRO/System Product
Name
Jan 27 20:18:34 jaunty kernel: [80403.946050] RIP:
0010:[<ffffffffa026f197>]  [<ffffffffa026f197>]
x25_sendmsg+0x1a7/0x530 [x25]
Jan 27 20:18:34 jaunty kernel: [80403.946072] RSP:
0018:ffff880228dbfcb8  EFLAGS: 00010246
Jan 27 20:18:34 jaunty kernel: [80403.946083] RAX: 0000000000000080
RBX: ffff880228dbfd70 RCX: ffff880228dbfce4
Jan 27 20:18:34 jaunty kernel: [80403.946096] RDX: 00000000fffffe00
RSI: 0000000000000000 RDI: ffff8801ba89f050
Jan 27 20:18:34 jaunty kernel: [80403.946109] RBP: ffff880228dbfd18
R08: ffff88022aa91000 R09: 0000000000000000
Jan 27 20:18:34 jaunty kernel: [80403.946482] R10: 0000000000000000
R11: 0000000000000000 R12: ffff8801ba89f000
Jan 27 20:18:34 jaunty kernel: [80403.946495] R13: 0000000000000000
R14: 0000000000000000 R15: 0000000000000000
Jan 27 20:18:34 jaunty kernel: [80403.946509] FS:
00007f09b3013700(0000) GS:ffff8800bf460000(0000)
knlGS:0000000000000000
Jan 27 20:18:34 jaunty kernel: [80403.946523] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Jan 27 20:18:34 jaunty kernel: [80403.946534] CR2: 00000000000000b4
CR3: 00000001df992000 CR4: 00000000000006e0
Jan 27 20:18:34 jaunty kernel: [80403.946547] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Jan 27 20:18:34 jaunty kernel: [80403.946560] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 27 20:18:34 jaunty kernel: [80403.946574] Process x25echotest
(pid: 28187, threadinfo ffff880228dbe000, task ffff8801d89bc320)
Jan 27 20:18:34 jaunty kernel: [80403.946594]  ffff880200000008
0000000000000016 0000303030390009 0000000000000000
Jan 27 20:18:34 jaunty kernel: [80403.946616]  ffff880228db0000
fffffe00d8832450 0000000000000000 ffff880228dbfd38
Jan 27 20:18:34 jaunty kernel: [80403.946638]  ffff880228dbfec8
ffff880228dbfdf8 ffff8801de73b980 ffff880228dbfd70
Jan 27 20:18:34 jaunty kernel: [80403.946671]  [<ffffffff8140cdd3>]
sock_aio_write+0x183/0x1a0
Jan 27 20:18:34 jaunty kernel: [80403.946686]  [<ffffffff8110304c>] ?
__pte_alloc+0xdc/0x100
Jan 27 20:18:34 jaunty kernel: [80403.946700]  [<ffffffff81138a5a>]
do_sync_write+0xda/0x120
Jan 27 20:18:34 jaunty kernel: [80403.946713]  [<ffffffff8140d026>] ?
move_addr_to_user+0x86/0xa0
Jan 27 20:18:34 jaunty kernel: [80403.946729]  [<ffffffff812431a3>] ?
security_file_permission+0x23/0x90
Jan 27 20:18:34 jaunty kernel: [80403.946743]  [<ffffffff8113903e>]
vfs_write+0x15e/0x180
Jan 27 20:18:34 jaunty kernel: [80403.946757]  [<ffffffff81139151>]
sys_write+0x51/0x90
Jan 27 20:18:34 jaunty kernel: [80403.946771]  [<ffffffff8100bf42>]
system_call_fastpath+0x16/0x1b
Jan 27 20:18:34 jaunty kernel: [80403.946973]  RSP <ffff880228dbfcb8>
Jan 27 20:18:34 jaunty kernel: [80403.950010] ---[ end trace
36cd53b6ce0d6f4b ]---

If i have done it right, x25_sendmsg+0x1a7/0x530 is the skb_reserve
which gets inlined here.
(af_x25.c)
        /* Build a packet */
        SOCK_DEBUG(sk, "x25_sendmsg: sendto: building packet.\n");

        if ((msg->msg_flags & MSG_OOB) && len > 32)
                len = 32;

        size = len + X25_MAX_L2_LEN + X25_EXT_MIN_LEN;

        release_sock(sk);
        skb = sock_alloc_send_skb(sk, size, noblock, &rc);
        lock_sock(sk);

        X25_SKB_CB(skb)->flags = msg->msg_flags;

        skb_reserve(skb, X25_MAX_L2_LEN + X25_EXT_MIN_LEN);

        /*
         *      Put the data on the end
         */
        SOCK_DEBUG(sk, "x25_sendmsg: Copying user data\n");



objdump -dS show it at 2197 here.

static inline void skb_reserve(struct sk_buff *skb, int len)
{
        skb->data += len;
        skb->tail += len;
    2197:       41 83 87 b4 00 00 00    addl   $0x16,0xb4(%r15) <---
    219e:       16
    219f:       41 89 47 28             mov    %eax,0x28(%r15)
    21a3:       49 8b 87 c8 00 00 00    mov    0xc8(%r15),%rax
    21aa:       48 83 c0 16             add    $0x16,%rax
        skb_reserve(skb, X25_MAX_L2_LEN + X25_EXT_MIN_LEN);

But im not sure where to go from there...



On Wed, Jan 26, 2011 at 9:17 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> This replaces all instances of lock_kernel in x25
> with lock_sock, taking care to release the socket
> lock around sleeping functions (sock_alloc_send_skb
> and skb_recv_datagram). It is not clear whether
> this is a correct solution, but it seem to be what
> other protocols do in the same situation.
>
> Compile-tested only.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Andrew Hendry <andrew.hendry@gmail.com>
> Cc: linux-x25@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
>  net/x25/Kconfig   |    1 -
>  net/x25/af_x25.c  |   61 ++++++++++++++++------------------------------------
>  net/x25/x25_out.c |    7 ++++-
>  3 files changed, 24 insertions(+), 45 deletions(-)
>
> diff --git a/net/x25/Kconfig b/net/x25/Kconfig
> index 2196e55..e6759c9 100644
> --- a/net/x25/Kconfig
> +++ b/net/x25/Kconfig
> @@ -5,7 +5,6 @@
>  config X25
>        tristate "CCITT X.25 Packet Layer (EXPERIMENTAL)"
>        depends on EXPERIMENTAL
> -       depends on BKL # should be fixable
>        ---help---
>          X.25 is a set of standardized network protocols, similar in scope to
>          frame relay; the one physical line from your box to the X.25 network
> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
> index ad96ee9..8f5d1bb 100644
> --- a/net/x25/af_x25.c
> +++ b/net/x25/af_x25.c
> @@ -40,7 +40,6 @@
>  #include <linux/errno.h>
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
> -#include <linux/smp_lock.h>
>  #include <linux/timer.h>
>  #include <linux/string.h>
>  #include <linux/net.h>
> @@ -432,15 +431,6 @@ void x25_destroy_socket_from_timer(struct sock *sk)
>        sock_put(sk);
>  }
>
> -static void x25_destroy_socket(struct sock *sk)
> -{
> -       sock_hold(sk);
> -       lock_sock(sk);
> -       __x25_destroy_socket(sk);
> -       release_sock(sk);
> -       sock_put(sk);
> -}
> -
>  /*
>  *     Handling for system calls applied via the various interfaces to a
>  *     X.25 socket object.
> @@ -647,18 +637,19 @@ static int x25_release(struct socket *sock)
>        struct sock *sk = sock->sk;
>        struct x25_sock *x25;
>
> -       lock_kernel();
>        if (!sk)
> -               goto out;
> +               return 0;
>
>        x25 = x25_sk(sk);
>
> +       sock_hold(sk);
> +       lock_sock(sk);
>        switch (x25->state) {
>
>                case X25_STATE_0:
>                case X25_STATE_2:
>                        x25_disconnect(sk, 0, 0, 0);
> -                       x25_destroy_socket(sk);
> +                       __x25_destroy_socket(sk);
>                        goto out;
>
>                case X25_STATE_1:
> @@ -678,7 +669,8 @@ static int x25_release(struct socket *sock)
>
>        sock_orphan(sk);
>  out:
> -       unlock_kernel();
> +       release_sock(sk);
> +       sock_put(sk);
>        return 0;
>  }
>
> @@ -1085,7 +1077,7 @@ static int x25_sendmsg(struct kiocb *iocb, struct socket *sock,
>        size_t size;
>        int qbit = 0, rc = -EINVAL;
>
> -       lock_kernel();
> +       lock_sock(sk);
>        if (msg->msg_flags & ~(MSG_DONTWAIT|MSG_OOB|MSG_EOR|MSG_CMSG_COMPAT))
>                goto out;
>
> @@ -1148,9 +1140,10 @@ static int x25_sendmsg(struct kiocb *iocb, struct socket *sock,
>
>        size = len + X25_MAX_L2_LEN + X25_EXT_MIN_LEN;
>
> +       release_sock(sk);
>        skb = sock_alloc_send_skb(sk, size, noblock, &rc);
> -       if (!skb)
> -               goto out;
> +       lock_sock(sk);
> +
>        X25_SKB_CB(skb)->flags = msg->msg_flags;
>
>        skb_reserve(skb, X25_MAX_L2_LEN + X25_EXT_MIN_LEN);
> @@ -1231,26 +1224,10 @@ static int x25_sendmsg(struct kiocb *iocb, struct socket *sock,
>                        len++;
>        }
>
> -       /*
> -        * lock_sock() is currently only used to serialize this x25_kick()
> -        * against input-driven x25_kick() calls. It currently only blocks
> -        * incoming packets for this socket and does not protect against
> -        * any other socket state changes and is not called from anywhere
> -        * else. As x25_kick() cannot block and as long as all socket
> -        * operations are BKL-wrapped, we don't need take to care about
> -        * purging the backlog queue in x25_release().
> -        *
> -        * Using lock_sock() to protect all socket operations entirely
> -        * (and making the whole x25 stack SMP aware) unfortunately would
> -        * require major changes to {send,recv}msg and skb allocation methods.
> -        * -> 2.5 ;)
> -        */
> -       lock_sock(sk);
>        x25_kick(sk);
> -       release_sock(sk);
>        rc = len;
>  out:
> -       unlock_kernel();
> +       release_sock(sk);
>        return rc;
>  out_kfree_skb:
>        kfree_skb(skb);
> @@ -1271,7 +1248,7 @@ static int x25_recvmsg(struct kiocb *iocb, struct socket *sock,
>        unsigned char *asmptr;
>        int rc = -ENOTCONN;
>
> -       lock_kernel();
> +       lock_sock(sk);
>        /*
>         * This works for seqpacket too. The receiver has ordered the queue for
>         * us! We do one quick check first though
> @@ -1300,8 +1277,10 @@ static int x25_recvmsg(struct kiocb *iocb, struct socket *sock,
>                msg->msg_flags |= MSG_OOB;
>        } else {
>                /* Now we can treat all alike */
> +               release_sock(sk);
>                skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
>                                        flags & MSG_DONTWAIT, &rc);
> +               lock_sock(sk);
>                if (!skb)
>                        goto out;
>
> @@ -1338,14 +1317,12 @@ static int x25_recvmsg(struct kiocb *iocb, struct socket *sock,
>
>        msg->msg_namelen = sizeof(struct sockaddr_x25);
>
> -       lock_sock(sk);
>        x25_check_rbuf(sk);
> -       release_sock(sk);
>        rc = copied;
>  out_free_dgram:
>        skb_free_datagram(sk, skb);
>  out:
> -       unlock_kernel();
> +       release_sock(sk);
>        return rc;
>  }
>
> @@ -1581,18 +1558,18 @@ out_cud_release:
>
>                case SIOCX25CALLACCPTAPPRV: {
>                        rc = -EINVAL;
> -                       lock_kernel();
> +                       lock_sock(sk);
>                        if (sk->sk_state != TCP_CLOSE)
>                                break;
>                        clear_bit(X25_ACCPT_APPRV_FLAG, &x25->flags);
> -                       unlock_kernel();
> +                       release_sock(sk);
>                        rc = 0;
>                        break;
>                }
>
>                case SIOCX25SENDCALLACCPT:  {
>                        rc = -EINVAL;
> -                       lock_kernel();
> +                       lock_sock(sk);
>                        if (sk->sk_state != TCP_ESTABLISHED)
>                                break;
>                        /* must call accptapprv above */
> @@ -1600,7 +1577,7 @@ out_cud_release:
>                                break;
>                        x25_write_internal(sk, X25_CALL_ACCEPTED);
>                        x25->state = X25_STATE_3;
> -                       unlock_kernel();
> +                       release_sock(sk);
>                        rc = 0;
>                        break;
>                }
> diff --git a/net/x25/x25_out.c b/net/x25/x25_out.c
> index d00649f..f1a6ff1 100644
> --- a/net/x25/x25_out.c
> +++ b/net/x25/x25_out.c
> @@ -68,8 +68,11 @@ int x25_output(struct sock *sk, struct sk_buff *skb)
>                frontlen = skb_headroom(skb);
>
>                while (skb->len > 0) {
> -                       if ((skbn = sock_alloc_send_skb(sk, frontlen + max_len,
> -                                                       noblock, &err)) == NULL){
> +                       release_sock(sk);
> +                       skbn = sock_alloc_send_skb(sk, frontlen + max_len,
> +                                                  1, &err);
> +                       lock_sock(sk);
> +                       if (!skbn) {
>                                if (err == -EWOULDBLOCK && noblock){
>                                        kfree_skb(skb);
>                                        return sent;
> --
> 1.7.1
>
