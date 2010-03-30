Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0C3FXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 01:23:45 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:57124 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0C3FXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 01:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g7iNIICWGRBwrOshzVEqq7WVxw/BGkCTFBB4rEtIh7puZrkvrSxiQb9tNSkEIxYMRW
         zbCZnyZY3uIr/RGxr7sdEpCsgQC7k6ffZnx8CyTIqeOJO55sYPj6G5Nz2zz4LeG/kcmH
         617/6ZEPjEnM41A+okHpqFC5z6E/zCNJNHhO0=
MIME-Version: 1.0
In-Reply-To: <524f69651003162020v43b7d9cfh5b409fc1a4d0f716@mail.gmail.com>
References: <1268778571.1652.8.camel@Joe-Laptop.home>
	 <524f69651003162020v43b7d9cfh5b409fc1a4d0f716@mail.gmail.com>
Date: Tue, 30 Mar 2010 00:23:39 -0500
Message-ID: <524f69651003292223t229cfb59xedf8bdb4bdb45102@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs: Neaten cERROR and cFYI macros, reduce text space 
	~2.5K
From: Steve French <smfrench@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged the equivalent into smb2.git

Due to its large size, would prefer to wait on the cifs version of
this until next merge window.

On Tue, Mar 16, 2010 at 10:20 PM, Steve French <smfrench@gmail.com> wrote:
> seems like a good idea - reviewing now.
>
> On Tue, Mar 16, 2010 at 5:29 PM, Joe Perches <joe@perches.com> wrote:
>> Convert '__FILE__ ": " fmt' to '"%s: " fmt', __FILE__' to save text space
>> Surround macros with do {} while
>> Add parentheses to macros
>> Make statement expression macro from macro with assign
>> Remove now unnecessary parentheses from cFYI and cERROR uses
>>
>> defconfig with CIFS support old
>> $ size fs/cifs/built-in.o
>>   text    data     bss     dec     hex filename
>>  156012    1760     148  157920   268e0 fs/cifs/built-in.o
>>
>> defconfig with CIFS support old
>> $ size fs/cifs/built-in.o
>>   text    data     bss     dec     hex filename
>>  153508    1760     148  155416   25f18 fs/cifs/built-in.o
>>
>> allyesconfig old:
>> $ size fs/cifs/built-in.o
>>   text    data     bss     dec     hex filename
>>  309138    3864   74824  387826   5eaf2 fs/cifs/built-in.o
>>
>> allyesconfig new
>> $ size fs/cifs/built-in.o
>>   text    data     bss     dec     hex filename
>>  305655    3864   74824  384343   5dd57 fs/cifs/built-in.o
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>>  fs/cifs/asn1.c         |   73 ++++-----
>>  fs/cifs/cifs_debug.c   |   34 ++--
>>  fs/cifs/cifs_debug.h   |   42 ++++--
>>  fs/cifs/cifs_dfs_ref.c |   34 ++--
>>  fs/cifs/cifs_spnego.c  |    2 +-
>>  fs/cifs/cifs_unicode.c |    5 +-
>>  fs/cifs/cifsacl.c      |   76 +++++-----
>>  fs/cifs/cifsencrypt.c  |    8 +-
>>  fs/cifs/cifsfs.c       |   37 ++---
>>  fs/cifs/cifsproto.h    |   16 ++-
>>  fs/cifs/cifssmb.c      |  401 ++++++++++++++++++++++++------------------------
>>  fs/cifs/connect.c      |  254 +++++++++++++++----------------
>>  fs/cifs/dir.c          |   43 +++---
>>  fs/cifs/dns_resolve.c  |   16 +-
>>  fs/cifs/export.c       |    2 +-
>>  fs/cifs/file.c         |  174 ++++++++++-----------
>>  fs/cifs/inode.c        |   98 ++++++------
>>  fs/cifs/ioctl.c        |   10 +-
>>  fs/cifs/link.c         |   10 +-
>>  fs/cifs/misc.c         |   81 +++++-----
>>  fs/cifs/netmisc.c      |   16 +-
>>  fs/cifs/readdir.c      |   85 +++++-----
>>  fs/cifs/sess.c         |   58 ++++----
>>  fs/cifs/transport.c    |   91 ++++++------
>>  fs/cifs/xattr.c        |   40 +++---
>>  25 files changed, 858 insertions(+), 848 deletions(-)
>>
>> diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
>> index a20bea5..6d555c0 100644
>> --- a/fs/cifs/asn1.c
>> +++ b/fs/cifs/asn1.c
>> @@ -510,11 +510,11 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>>
>>        /* GSSAPI header */
>>        if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>> -               cFYI(1, ("Error decoding negTokenInit header"));
>> +               cFYI(1, "Error decoding negTokenInit header");
>>                return 0;
>>        } else if ((cls != ASN1_APL) || (con != ASN1_CON)
>>                   || (tag != ASN1_EOC)) {
>> -               cFYI(1, ("cls = %d con = %d tag = %d", cls, con, tag));
>> +               cFYI(1, "cls = %d con = %d tag = %d", cls, con, tag);
>>                return 0;
>>        }
>>
>> @@ -535,56 +535,52 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>>
>>        /* SPNEGO OID not present or garbled -- bail out */
>>        if (!rc) {
>> -               cFYI(1, ("Error decoding negTokenInit header"));
>> +               cFYI(1, "Error decoding negTokenInit header");
>>                return 0;
>>        }
>>
>>        /* SPNEGO */
>>        if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>> -               cFYI(1, ("Error decoding negTokenInit"));
>> +               cFYI(1, "Error decoding negTokenInit");
>>                return 0;
>>        } else if ((cls != ASN1_CTX) || (con != ASN1_CON)
>>                   || (tag != ASN1_EOC)) {
>> -               cFYI(1,
>> -                    ("cls = %d con = %d tag = %d end = %p (%d) exit 0",
>> -                     cls, con, tag, end, *end));
>> +               cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 0",
>> +                    cls, con, tag, end, *end);
>>                return 0;
>>        }
>>
>>        /* negTokenInit */
>>        if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>> -               cFYI(1, ("Error decoding negTokenInit"));
>> +               cFYI(1, "Error decoding negTokenInit");
>>                return 0;
>>        } else if ((cls != ASN1_UNI) || (con != ASN1_CON)
>>                   || (tag != ASN1_SEQ)) {
>> -               cFYI(1,
>> -                    ("cls = %d con = %d tag = %d end = %p (%d) exit 1",
>> -                     cls, con, tag, end, *end));
>> +               cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 1",
>> +                    cls, con, tag, end, *end);
>>                return 0;
>>        }
>>
>>        /* sequence */
>>        if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>> -               cFYI(1, ("Error decoding 2nd part of negTokenInit"));
>> +               cFYI(1, "Error decoding 2nd part of negTokenInit");
>>                return 0;
>>        } else if ((cls != ASN1_CTX) || (con != ASN1_CON)
>>                   || (tag != ASN1_EOC)) {
>> -               cFYI(1,
>> -                    ("cls = %d con = %d tag = %d end = %p (%d) exit 0",
>> -                     cls, con, tag, end, *end));
>> +               cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 0",
>> +                    cls, con, tag, end, *end);
>>                return 0;
>>        }
>>
>>        /* sequence of */
>>        if (asn1_header_decode
>>            (&ctx, &sequence_end, &cls, &con, &tag) == 0) {
>> -               cFYI(1, ("Error decoding 2nd part of negTokenInit"));
>> +               cFYI(1, "Error decoding 2nd part of negTokenInit");
>>                return 0;
>>        } else if ((cls != ASN1_UNI) || (con != ASN1_CON)
>>                   || (tag != ASN1_SEQ)) {
>> -               cFYI(1,
>> -                    ("cls = %d con = %d tag = %d end = %p (%d) exit 1",
>> -                     cls, con, tag, end, *end));
>> +               cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 1",
>> +                    cls, con, tag, end, *end);
>>                return 0;
>>        }
>>
>> @@ -592,16 +588,15 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>>        while (!asn1_eoc_decode(&ctx, sequence_end)) {
>>                rc = asn1_header_decode(&ctx, &end, &cls, &con, &tag);
>>                if (!rc) {
>> -                       cFYI(1,
>> -                            ("Error decoding negTokenInit hdr exit2"));
>> +                       cFYI(1, "Error decoding negTokenInit hdr exit2");
>>                        return 0;
>>                }
>>                if ((tag == ASN1_OJI) && (con == ASN1_PRI)) {
>>                        if (asn1_oid_decode(&ctx, end, &oid, &oidlen)) {
>>
>> -                               cFYI(1, ("OID len = %d oid = 0x%lx 0x%lx "
>> -                                        "0x%lx 0x%lx", oidlen, *oid,
>> -                                        *(oid + 1), *(oid + 2), *(oid + 3)));
>> +                               cFYI(1, "OID len = %d oid = 0x%lx 0x%lx "
>> +                                       "0x%lx 0x%lx", oidlen, *oid,
>> +                                       *(oid + 1), *(oid + 2), *(oid + 3));
>>
>>                                if (compare_oid(oid, oidlen, MSKRB5_OID,
>>                                                MSKRB5_OID_LEN) &&
>> @@ -622,7 +617,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>>                                kfree(oid);
>>                        }
>>                } else {
>> -                       cFYI(1, ("Should be an oid what is going on?"));
>> +                       cFYI(1, "Should be an oid what is going on?");
>>                }
>>        }
>>
>> @@ -632,47 +627,47 @@ decode_negTokenInit(unsigned char *security_blob, int length,
>>                   no mechListMic (e.g. NTLMSSP instead of KRB5) */
>>                if (ctx.error == ASN1_ERR_DEC_EMPTY)
>>                        goto decode_negtoken_exit;
>> -               cFYI(1, ("Error decoding last part negTokenInit exit3"));
>> +               cFYI(1, "Error decoding last part negTokenInit exit3");
>>                return 0;
>>        } else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
>>                /* tag = 3 indicating mechListMIC */
>> -               cFYI(1, ("Exit 4 cls = %d con = %d tag = %d end = %p (%d)",
>> -                        cls, con, tag, end, *end));
>> +               cFYI(1, "Exit 4 cls = %d con = %d tag = %d end = %p (%d)",
>> +                       cls, con, tag, end, *end);
>>                return 0;
>>        }
>>
>>        /* sequence */
>>        if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>> -               cFYI(1, ("Error decoding last part negTokenInit exit5"));
>> +               cFYI(1, "Error decoding last part negTokenInit exit5");
>>                return 0;
>>        } else if ((cls != ASN1_UNI) || (con != ASN1_CON)
>>                   || (tag != ASN1_SEQ)) {
>> -               cFYI(1, ("cls = %d con = %d tag = %d end = %p (%d)",
>> -                       cls, con, tag, end, *end));
>> +               cFYI(1, "cls = %d con = %d tag = %d end = %p (%d)",
>> +                       cls, con, tag, end, *end);
>>        }
>>
>>        /* sequence of */
>>        if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>> -               cFYI(1, ("Error decoding last part negTokenInit exit 7"));
>> +               cFYI(1, "Error decoding last part negTokenInit exit 7");
>>                return 0;
>>        } else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
>> -               cFYI(1, ("Exit 8 cls = %d con = %d tag = %d end = %p (%d)",
>> -                        cls, con, tag, end, *end));
>> +               cFYI(1, "Exit 8 cls = %d con = %d tag = %d end = %p (%d)",
>> +                       cls, con, tag, end, *end);
>>                return 0;
>>        }
>>
>>        /* general string */
>>        if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
>> -               cFYI(1, ("Error decoding last part negTokenInit exit9"));
>> +               cFYI(1, "Error decoding last part negTokenInit exit9");
>>                return 0;
>>        } else if ((cls != ASN1_UNI) || (con != ASN1_PRI)
>>                   || (tag != ASN1_GENSTR)) {
>> -               cFYI(1, ("Exit10 cls = %d con = %d tag = %d end = %p (%d)",
>> -                        cls, con, tag, end, *end));
>> +               cFYI(1, "Exit10 cls = %d con = %d tag = %d end = %p (%d)",
>> +                       cls, con, tag, end, *end);
>>                return 0;
>>        }
>> -       cFYI(1, ("Need to call asn1_octets_decode() function for %s",
>> -                ctx.pointer)); /* is this UTF-8 or ASCII? */
>> +       cFYI(1, "Need to call asn1_octets_decode() function for %s",
>> +               ctx.pointer);   /* is this UTF-8 or ASCII? */
>>  decode_negtoken_exit:
>>        if (use_kerberos)
>>                *secType = Kerberos;
>> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
>> index 42cec2a..5495180 100644
>> --- a/fs/cifs/cifs_debug.c
>> +++ b/fs/cifs/cifs_debug.c
>> @@ -60,10 +60,10 @@ cifs_dump_mem(char *label, void *data, int length)
>>  #ifdef CONFIG_CIFS_DEBUG2
>>  void cifs_dump_detail(struct smb_hdr *smb)
>>  {
>> -       cERROR(1, ("Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
>> +       cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
>>                  smb->Command, smb->Status.CifsError,
>> -                 smb->Flags, smb->Flags2, smb->Mid, smb->Pid));
>> -       cERROR(1, ("smb buf %p len %d", smb, smbCalcSize_LE(smb)));
>> +                 smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
>> +       cERROR(1, "smb buf %p len %d", smb, smbCalcSize_LE(smb));
>>  }
>>
>>
>> @@ -75,25 +75,25 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
>>        if (server == NULL)
>>                return;
>>
>> -       cERROR(1, ("Dump pending requests:"));
>> +       cERROR(1, "Dump pending requests:");
>>        spin_lock(&GlobalMid_Lock);
>>        list_for_each(tmp, &server->pending_mid_q) {
>>                mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
>> -               cERROR(1, ("State: %d Cmd: %d Pid: %d Tsk: %p Mid %d",
>> +               cERROR(1, "State: %d Cmd: %d Pid: %d Tsk: %p Mid %d",
>>                        mid_entry->midState,
>>                        (int)mid_entry->command,
>>                        mid_entry->pid,
>>                        mid_entry->tsk,
>> -                       mid_entry->mid));
>> +                       mid_entry->mid);
>>  #ifdef CONFIG_CIFS_STATS2
>> -               cERROR(1, ("IsLarge: %d buf: %p time rcv: %ld now: %ld",
>> +               cERROR(1, "IsLarge: %d buf: %p time rcv: %ld now: %ld",
>>                        mid_entry->largeBuf,
>>                        mid_entry->resp_buf,
>>                        mid_entry->when_received,
>> -                       jiffies));
>> +                       jiffies);
>>  #endif /* STATS2 */
>> -               cERROR(1, ("IsMult: %d IsEnd: %d", mid_entry->multiRsp,
>> -                         mid_entry->multiEnd));
>> +               cERROR(1, "IsMult: %d IsEnd: %d", mid_entry->multiRsp,
>> +                         mid_entry->multiEnd);
>>                if (mid_entry->resp_buf) {
>>                        cifs_dump_detail(mid_entry->resp_buf);
>>                        cifs_dump_mem("existing buf: ",
>> @@ -750,7 +750,7 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
>>                        extended_security = CIFSSEC_MAX;
>>                        return count;
>>                } else if (!isdigit(c)) {
>> -                       cERROR(1, ("invalid flag %c", c));
>> +                       cERROR(1, "invalid flag %c", c);
>>                        return -EINVAL;
>>                }
>>        }
>> @@ -758,16 +758,16 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
>>
>>        flags = simple_strtoul(flags_string, NULL, 0);
>>
>> -       cFYI(1, ("sec flags 0x%x", flags));
>> +       cFYI(1, "sec flags 0x%x", flags);
>>
>>        if (flags <= 0)  {
>> -               cERROR(1, ("invalid security flags %s", flags_string));
>> +               cERROR(1, "invalid security flags %s", flags_string);
>>                return -EINVAL;
>>        }
>>
>>        if (flags & ~CIFSSEC_MASK) {
>> -               cERROR(1, ("attempt to set unsupported security flags 0x%x",
>> -                       flags & ~CIFSSEC_MASK));
>> +               cERROR(1, "attempt to set unsupported security flags 0x%x",
>> +                       flags & ~CIFSSEC_MASK);
>>                return -EINVAL;
>>        }
>>        /* flags look ok - update the global security flags for cifs module */
>> @@ -775,9 +775,9 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
>>        if (extended_security & CIFSSEC_MUST_SIGN) {
>>                /* requiring signing implies signing is allowed */
>>                extended_security |= CIFSSEC_MAY_SIGN;
>> -               cFYI(1, ("packet signing now required"));
>> +               cFYI(1, "packet signing now required");
>>        } else if ((extended_security & CIFSSEC_MAY_SIGN) == 0) {
>> -               cFYI(1, ("packet signing disabled"));
>> +               cFYI(1, "packet signing disabled");
>>        }
>>        /* BB should we turn on MAY flags for other MUST options? */
>>        return count;
>> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
>> index 5eb3b83..aa31689 100644
>> --- a/fs/cifs/cifs_debug.h
>> +++ b/fs/cifs/cifs_debug.h
>> @@ -43,34 +43,54 @@ void dump_smb(struct smb_hdr *, int);
>>  */
>>  #ifdef CIFS_DEBUG
>>
>> -
>>  /* information message: e.g., configuration, major event */
>>  extern int cifsFYI;
>> -#define cifsfyi(format,arg...) if (cifsFYI & CIFS_INFO) printk(KERN_DEBUG " " __FILE__ ": " format "\n" "" , ## arg)
>> +#define cifsfyi(fmt, arg...)                                           \
>> +do {                                                                   \
>> +       if (cifsFYI & CIFS_INFO)                                        \
>> +               printk(KERN_DEBUG "%s: " fmt "\n", __FILE__, ##arg);    \
>> +} while (0)
>>
>> -#define cFYI(button,prspec) if (button) cifsfyi prspec
>> +#define cFYI(set, fmt, arg...)                 \
>> +do {                                           \
>> +       if (set)                                \
>> +               cifsfyi(fmt, ##arg);            \
>> +} while (0)
>>
>> -#define cifswarn(format, arg...) printk(KERN_WARNING ": " format "\n" , ## arg)
>> +#define cifswarn(fmt, arg...)                  \
>> +       printk(KERN_WARNING fmt "\n", ##arg)
>>
>>  /* debug event message: */
>>  extern int cifsERROR;
>>
>> -#define cEVENT(format,arg...) if (cifsERROR) printk(KERN_EVENT __FILE__ ": " format "\n" , ## arg)
>> +#define cEVENT(fmt, arg...)                                            \
>> +do {                                                                   \
>> +       if (cifsERROR)                                                  \
>> +               printk(KERN_EVENT "%s: " fmt "\n", __FILE__, ##arg);    \
>> +} while (0)
>>
>>  /* error event message: e.g., i/o error */
>> -#define cifserror(format,arg...) if (cifsERROR) printk(KERN_ERR " CIFS VFS: " format "\n" "" , ## arg)
>> +#define cifserror(fmt, arg...)                                 \
>> +do {                                                           \
>> +       if (cifsERROR)                                          \
>> +               printk(KERN_ERR "CIFS VFS: " fmt "\n", ##arg);  \
>> +} while (0)
>>
>> -#define cERROR(button, prspec) if (button) cifserror prspec
>> +#define cERROR(set, fmt, arg...)               \
>> +do {                                           \
>> +       if (set)                                \
>> +               cifserror(fmt, ##arg);          \
>> +} while (0)
>>
>>  /*
>>  *     debug OFF
>>  *     ---------
>>  */
>>  #else          /* _CIFS_DEBUG */
>> -#define cERROR(button, prspec)
>> -#define cEVENT(format, arg...)
>> -#define cFYI(button, prspec)
>> -#define cifserror(format, arg...)
>> +#define cERROR(set, fmt, arg...)
>> +#define cEVENT(fmt, arg...)
>> +#define cFYI(set, fmt, arg...)
>> +#define cifserror(fmt, arg...)
>>  #endif         /* _CIFS_DEBUG */
>>
>>  #endif                         /* _H_CIFS_DEBUG */
>> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
>> index b1d61d0..ff5a4cb 100644
>> --- a/fs/cifs/cifs_dfs_ref.c
>> +++ b/fs/cifs/cifs_dfs_ref.c
>> @@ -84,8 +84,8 @@ static char *cifs_get_share_name(const char *node_name)
>>        /* find server name end */
>>        pSep = memchr(UNC+2, '\\', len-2);
>>        if (!pSep) {
>> -               cERROR(1, ("%s: no server name end in node name: %s",
>> -                       __func__, node_name));
>> +               cERROR(1, "%s: no server name end in node name: %s",
>> +                       __func__, node_name);
>>                kfree(UNC);
>>                return ERR_PTR(-EINVAL);
>>        }
>> @@ -141,8 +141,8 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
>>
>>        rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
>>        if (rc != 0) {
>> -               cERROR(1, ("%s: Failed to resolve server part of %s to IP: %d",
>> -                         __func__, *devname, rc));
>> +               cERROR(1, "%s: Failed to resolve server part of %s to IP: %d",
>> +                         __func__, *devname, rc);
>>                goto compose_mount_options_err;
>>        }
>>        /* md_len = strlen(...) + 12 for 'sep+prefixpath='
>> @@ -216,8 +216,8 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
>>                strcat(mountdata, fullpath + ref->path_consumed);
>>        }
>>
>> -       /*cFYI(1,("%s: parent mountdata: %s", __func__,sb_mountdata));*/
>> -       /*cFYI(1, ("%s: submount mountdata: %s", __func__, mountdata ));*/
>> +       /*cFYI(1, "%s: parent mountdata: %s", __func__,sb_mountdata);*/
>> +       /*cFYI(1, "%s: submount mountdata: %s", __func__, mountdata );*/
>>
>>  compose_mount_options_out:
>>        kfree(srvIP);
>> @@ -293,11 +293,11 @@ static int add_mount_helper(struct vfsmount *newmnt, struct nameidata *nd,
>>
>>  static void dump_referral(const struct dfs_info3_param *ref)
>>  {
>> -       cFYI(1, ("DFS: ref path: %s", ref->path_name));
>> -       cFYI(1, ("DFS: node path: %s", ref->node_name));
>> -       cFYI(1, ("DFS: fl: %hd, srv_type: %hd", ref->flags, ref->server_type));
>> -       cFYI(1, ("DFS: ref_flags: %hd, path_consumed: %hd", ref->ref_flag,
>> -                               ref->path_consumed));
>> +       cFYI(1, "DFS: ref path: %s", ref->path_name);
>> +       cFYI(1, "DFS: node path: %s", ref->node_name);
>> +       cFYI(1, "DFS: fl: %hd, srv_type: %hd", ref->flags, ref->server_type);
>> +       cFYI(1, "DFS: ref_flags: %hd, path_consumed: %hd", ref->ref_flag,
>> +                               ref->path_consumed);
>>  }
>>
>>
>> @@ -313,7 +313,7 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
>>        int rc = 0;
>>        struct vfsmount *mnt = ERR_PTR(-ENOENT);
>>
>> -       cFYI(1, ("in %s", __func__));
>> +       cFYI(1, "in %s", __func__);
>>        BUG_ON(IS_ROOT(dentry));
>>
>>        xid = GetXid();
>> @@ -351,15 +351,15 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
>>                /* connect to a node */
>>                len = strlen(referrals[i].node_name);
>>                if (len < 2) {
>> -                       cERROR(1, ("%s: Net Address path too short: %s",
>> -                                       __func__, referrals[i].node_name));
>> +                       cERROR(1, "%s: Net Address path too short: %s",
>> +                                       __func__, referrals[i].node_name);
>>                        rc = -EINVAL;
>>                        goto out_err;
>>                }
>>                mnt = cifs_dfs_do_refmount(nd->path.mnt,
>>                                nd->path.dentry, referrals + i);
>> -               cFYI(1, ("%s: cifs_dfs_do_refmount:%s , mnt:%p", __func__,
>> -                                       referrals[i].node_name, mnt));
>> +               cFYI(1, "%s: cifs_dfs_do_refmount:%s , mnt:%p", __func__,
>> +                                       referrals[i].node_name, mnt);
>>
>>                /* complete mount procedure if we accured submount */
>>                if (!IS_ERR(mnt))
>> @@ -377,7 +377,7 @@ out:
>>        FreeXid(xid);
>>        free_dfs_info_array(referrals, num_referrals);
>>        kfree(full_path);
>> -       cFYI(1, ("leaving %s" , __func__));
>> +       cFYI(1, "leaving %s" , __func__);
>>        return ERR_PTR(rc);
>>  out_err:
>>        path_put(&nd->path);
>> diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
>> index 8ec7736..69b11a6 100644
>> --- a/fs/cifs/cifs_spnego.c
>> +++ b/fs/cifs/cifs_spnego.c
>> @@ -148,7 +148,7 @@ cifs_get_spnego_key(struct cifsSesInfo *sesInfo)
>>        dp = description + strlen(description);
>>        sprintf(dp, ";pid=0x%x", current->pid);
>>
>> -       cFYI(1, ("key description = %s", description));
>> +       cFYI(1, "key description = %s", description);
>>        spnego_key = request_key(&cifs_spnego_key_type, description, "");
>>
>>  #ifdef CONFIG_CIFS_DEBUG2
>> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
>> index 714a542..6de3139 100644
>> --- a/fs/cifs/cifs_unicode.c
>> +++ b/fs/cifs/cifs_unicode.c
>> @@ -199,9 +199,8 @@ cifs_strtoUCS(__le16 *to, const char *from, int len,
>>                /* works for 2.4.0 kernel or later */
>>                charlen = codepage->char2uni(from, len, &wchar_to[i]);
>>                if (charlen < 1) {
>> -                       cERROR(1,
>> -                              ("strtoUCS: char2uni of %d returned %d",
>> -                               (int)*from, charlen));
>> +                       cERROR(1, "strtoUCS: char2uni of %d returned %d",
>> +                               (int)*from, charlen);
>>                        /* A question mark */
>>                        to[i] = cpu_to_le16(0x003f);
>>                        charlen = 1;
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index 7dfe084..174c308 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -86,11 +86,11 @@ int match_sid(struct cifs_sid *ctsid)
>>                                continue; /* all sub_auth values do not match */
>>                }
>>
>> -               cFYI(1, ("matching sid: %s\n", wksidarr[i].sidname));
>> +               cFYI(1, "matching sid: %s\n", wksidarr[i].sidname);
>>                return 0; /* sids compare/match */
>>        }
>>
>> -       cFYI(1, ("No matching sid"));
>> +       cFYI(1, "No matching sid");
>>        return -1;
>>  }
>>
>> @@ -207,14 +207,14 @@ static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
>>                        *pbits_to_set &= ~S_IXUGO;
>>                return;
>>        } else if (type != ACCESS_ALLOWED) {
>> -               cERROR(1, ("unknown access control type %d", type));
>> +               cERROR(1, "unknown access control type %d", type);
>>                return;
>>        }
>>        /* else ACCESS_ALLOWED type */
>>
>>        if (flags & GENERIC_ALL) {
>>                *pmode |= (S_IRWXUGO & (*pbits_to_set));
>> -               cFYI(DBG2, ("all perms"));
>> +               cFYI(DBG2, "all perms");
>>                return;
>>        }
>>        if ((flags & GENERIC_WRITE) ||
>> @@ -227,7 +227,7 @@ static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
>>                        ((flags & FILE_EXEC_RIGHTS) == FILE_EXEC_RIGHTS))
>>                *pmode |= (S_IXUGO & (*pbits_to_set));
>>
>> -       cFYI(DBG2, ("access flags 0x%x mode now 0x%x", flags, *pmode));
>> +       cFYI(DBG2, "access flags 0x%x mode now 0x%x", flags, *pmode);
>>        return;
>>  }
>>
>> @@ -256,7 +256,7 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
>>        if (mode & S_IXUGO)
>>                *pace_flags |= SET_FILE_EXEC_RIGHTS;
>>
>> -       cFYI(DBG2, ("mode: 0x%x, access flags now 0x%x", mode, *pace_flags));
>> +       cFYI(DBG2, "mode: 0x%x, access flags now 0x%x", mode, *pace_flags);
>>        return;
>>  }
>>
>> @@ -296,24 +296,24 @@ static void dump_ace(struct cifs_ace *pace, char *end_of_acl)
>>        /* validate that we do not go past end of acl */
>>
>>        if (le16_to_cpu(pace->size) < 16) {
>> -               cERROR(1, ("ACE too small, %d", le16_to_cpu(pace->size)));
>> +               cERROR(1, "ACE too small %d", le16_to_cpu(pace->size));
>>                return;
>>        }
>>
>>        if (end_of_acl < (char *)pace + le16_to_cpu(pace->size)) {
>> -               cERROR(1, ("ACL too small to parse ACE"));
>> +               cERROR(1, "ACL too small to parse ACE");
>>                return;
>>        }
>>
>>        num_subauth = pace->sid.num_subauth;
>>        if (num_subauth) {
>>                int i;
>> -               cFYI(1, ("ACE revision %d num_auth %d type %d flags %d size %d",
>> +               cFYI(1, "ACE revision %d num_auth %d type %d flags %d size %d",
>>                        pace->sid.revision, pace->sid.num_subauth, pace->type,
>> -                       pace->flags, le16_to_cpu(pace->size)));
>> +                       pace->flags, le16_to_cpu(pace->size));
>>                for (i = 0; i < num_subauth; ++i) {
>> -                       cFYI(1, ("ACE sub_auth[%d]: 0x%x", i,
>> -                               le32_to_cpu(pace->sid.sub_auth[i])));
>> +                       cFYI(1, "ACE sub_auth[%d]: 0x%x", i,
>> +                               le32_to_cpu(pace->sid.sub_auth[i]));
>>                }
>>
>>                /* BB add length check to make sure that we do not have huge
>> @@ -346,13 +346,13 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
>>
>>        /* validate that we do not go past end of acl */
>>        if (end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
>> -               cERROR(1, ("ACL too small to parse DACL"));
>> +               cERROR(1, "ACL too small to parse DACL");
>>                return;
>>        }
>>
>> -       cFYI(DBG2, ("DACL revision %d size %d num aces %d",
>> +       cFYI(DBG2, "DACL revision %d size %d num aces %d",
>>                le16_to_cpu(pdacl->revision), le16_to_cpu(pdacl->size),
>> -               le32_to_cpu(pdacl->num_aces)));
>> +               le32_to_cpu(pdacl->num_aces));
>>
>>        /* reset rwx permissions for user/group/other.
>>           Also, if num_aces is 0 i.e. DACL has no ACEs,
>> @@ -436,25 +436,25 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
>>        /* validate that we do not go past end of ACL - sid must be at least 8
>>           bytes long (assuming no sub-auths - e.g. the null SID */
>>        if (end_of_acl < (char *)psid + 8) {
>> -               cERROR(1, ("ACL too small to parse SID %p", psid));
>> +               cERROR(1, "ACL too small to parse SID %p", psid);
>>                return -EINVAL;
>>        }
>>
>>        if (psid->num_subauth) {
>>  #ifdef CONFIG_CIFS_DEBUG2
>>                int i;
>> -               cFYI(1, ("SID revision %d num_auth %d",
>> -                       psid->revision, psid->num_subauth));
>> +               cFYI(1, "SID revision %d num_auth %d",
>> +                       psid->revision, psid->num_subauth);
>>
>>                for (i = 0; i < psid->num_subauth; i++) {
>> -                       cFYI(1, ("SID sub_auth[%d]: 0x%x ", i,
>> -                               le32_to_cpu(psid->sub_auth[i])));
>> +                       cFYI(1, "SID sub_auth[%d]: 0x%x ", i,
>> +                               le32_to_cpu(psid->sub_auth[i]));
>>                }
>>
>>                /* BB add length check to make sure that we do not have huge
>>                        num auths and therefore go off the end */
>> -               cFYI(1, ("RID 0x%x",
>> -                       le32_to_cpu(psid->sub_auth[psid->num_subauth-1])));
>> +               cFYI(1, "RID 0x%x",
>> +                       le32_to_cpu(psid->sub_auth[psid->num_subauth-1]));
>>  #endif
>>        }
>>
>> @@ -481,11 +481,11 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
>>                                le32_to_cpu(pntsd->gsidoffset));
>>        dacloffset = le32_to_cpu(pntsd->dacloffset);
>>        dacl_ptr = (struct cifs_acl *)((char *)pntsd + dacloffset);
>> -       cFYI(DBG2, ("revision %d type 0x%x ooffset 0x%x goffset 0x%x "
>> +       cFYI(DBG2, "revision %d type 0x%x ooffset 0x%x goffset 0x%x "
>>                 "sacloffset 0x%x dacloffset 0x%x",
>>                 pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
>>                 le32_to_cpu(pntsd->gsidoffset),
>> -                le32_to_cpu(pntsd->sacloffset), dacloffset));
>> +                le32_to_cpu(pntsd->sacloffset), dacloffset);
>>  /*     cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
>>        rc = parse_sid(owner_sid_ptr, end_of_acl);
>>        if (rc)
>> @@ -499,7 +499,7 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
>>                parse_dacl(dacl_ptr, end_of_acl, owner_sid_ptr,
>>                           group_sid_ptr, fattr);
>>        else
>> -               cFYI(1, ("no ACL")); /* BB grant all or default perms? */
>> +               cFYI(1, "no ACL"); /* BB grant all or default perms? */
>>
>>  /*     cifscred->uid = owner_sid_ptr->rid;
>>        cifscred->gid = group_sid_ptr->rid;
>> @@ -562,7 +562,7 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
>>        FreeXid(xid);
>>
>>
>> -       cFYI(1, ("GetCIFSACL rc = %d ACL len %d", rc, *pacllen));
>> +       cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
>>        return pntsd;
>>  }
>>
>> @@ -580,12 +580,12 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
>>                         &fid, &oplock, NULL, cifs_sb->local_nls,
>>                         cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
>>        if (rc) {
>> -               cERROR(1, ("Unable to open file to get ACL"));
>> +               cERROR(1, "Unable to open file to get ACL");
>>                goto out;
>>        }
>>
>>        rc = CIFSSMBGetCIFSACL(xid, cifs_sb->tcon, fid, &pntsd, pacllen);
>> -       cFYI(1, ("GetCIFSACL rc = %d ACL len %d", rc, *pacllen));
>> +       cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
>>
>>        CIFSSMBClose(xid, cifs_sb->tcon, fid);
>>  out:
>> @@ -620,7 +620,7 @@ static int set_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb, __u16 fid,
>>        rc = CIFSSMBSetCIFSACL(xid, cifs_sb->tcon, fid, pnntsd, acllen);
>>        FreeXid(xid);
>>
>> -       cFYI(DBG2, ("SetCIFSACL rc = %d", rc));
>> +       cFYI(DBG2, "SetCIFSACL rc = %d", rc);
>>        return rc;
>>  }
>>
>> @@ -637,12 +637,12 @@ static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
>>                         &fid, &oplock, NULL, cifs_sb->local_nls,
>>                         cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
>>        if (rc) {
>> -               cERROR(1, ("Unable to open file to set ACL"));
>> +               cERROR(1, "Unable to open file to set ACL");
>>                goto out;
>>        }
>>
>>        rc = CIFSSMBSetCIFSACL(xid, cifs_sb->tcon, fid, pnntsd, acllen);
>> -       cFYI(DBG2, ("SetCIFSACL rc = %d", rc));
>> +       cFYI(DBG2, "SetCIFSACL rc = %d", rc);
>>
>>        CIFSSMBClose(xid, cifs_sb->tcon, fid);
>>  out:
>> @@ -658,7 +658,7 @@ static int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
>>        struct cifsFileInfo *open_file;
>>        int rc;
>>
>> -       cFYI(DBG2, ("set ACL for %s from mode 0x%x", path, inode->i_mode));
>> +       cFYI(DBG2, "set ACL for %s from mode 0x%x", path, inode->i_mode);
>>
>>        open_file = find_readable_file(CIFS_I(inode));
>>        if (!open_file)
>> @@ -678,7 +678,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
>>        u32 acllen = 0;
>>        int rc = 0;
>>
>> -       cFYI(DBG2, ("converting ACL to mode for %s", path));
>> +       cFYI(DBG2, "converting ACL to mode for %s", path);
>>
>>        if (pfid)
>>                pntsd = get_cifs_acl_by_fid(cifs_sb, *pfid, &acllen);
>> @@ -689,7 +689,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
>>        if (pntsd)
>>                rc = parse_sec_desc(pntsd, acllen, fattr);
>>        if (rc)
>> -               cFYI(1, ("parse sec desc failed rc = %d", rc));
>> +               cFYI(1, "parse sec desc failed rc = %d", rc);
>>
>>        kfree(pntsd);
>>        return;
>> @@ -703,7 +703,7 @@ int mode_to_acl(struct inode *inode, const char *path, __u64 nmode)
>>        struct cifs_ntsd *pntsd = NULL; /* acl obtained from server */
>>        struct cifs_ntsd *pnntsd = NULL; /* modified acl to be sent to server */
>>
>> -       cFYI(DBG2, ("set ACL from mode for %s", path));
>> +       cFYI(DBG2, "set ACL from mode for %s", path);
>>
>>        /* Get the security descriptor */
>>        pntsd = get_cifs_acl(CIFS_SB(inode->i_sb), inode, path, &secdesclen);
>> @@ -720,19 +720,19 @@ int mode_to_acl(struct inode *inode, const char *path, __u64 nmode)
>>                                        DEFSECDESCLEN : secdesclen;
>>                pnntsd = kmalloc(secdesclen, GFP_KERNEL);
>>                if (!pnntsd) {
>> -                       cERROR(1, ("Unable to allocate security descriptor"));
>> +                       cERROR(1, "Unable to allocate security descriptor");
>>                        kfree(pntsd);
>>                        return -ENOMEM;
>>                }
>>
>>                rc = build_sec_desc(pntsd, pnntsd, inode, nmode);
>>
>> -               cFYI(DBG2, ("build_sec_desc rc: %d", rc));
>> +               cFYI(DBG2, "build_sec_desc rc: %d", rc);
>>
>>                if (!rc) {
>>                        /* Set the security descriptor */
>>                        rc = set_cifs_acl(pnntsd, secdesclen, inode, path);
>> -                       cFYI(DBG2, ("set_cifs_acl rc: %d", rc));
>> +                       cFYI(DBG2, "set_cifs_acl rc: %d", rc);
>>                }
>>
>>                kfree(pnntsd);
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 7efe174..0cb77c9 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -102,7 +102,7 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
>>                if (iov[i].iov_len == 0)
>>                        continue;
>>                if (iov[i].iov_base == NULL) {
>> -                       cERROR(1, ("null iovec entry"));
>> +                       cERROR(1, "null iovec entry");
>>                        return -EIO;
>>                }
>>                /* The first entry includes a length field (which does not get
>> @@ -180,8 +180,8 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
>>
>>        /* Do not need to verify session setups with signature "BSRSPYL "  */
>>        if (memcmp(cifs_pdu->Signature.SecuritySignature, "BSRSPYL ", 8) == 0)
>> -               cFYI(1, ("dummy signature received for smb command 0x%x",
>> -                       cifs_pdu->Command));
>> +               cFYI(1, "dummy signature received for smb command 0x%x",
>> +                       cifs_pdu->Command);
>>
>>        /* save off the origiginal signature so we can modify the smb and check
>>                its signature against what the server sent */
>> @@ -397,7 +397,7 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>>        /* calculate buf->ntlmv2_hash */
>>        rc = calc_ntlmv2_hash(ses, nls_cp);
>>        if (rc)
>> -               cERROR(1, ("could not get v2 hash rc %d", rc));
>> +               cERROR(1, "could not get v2 hash rc %d", rc);
>>        CalcNTLMv2_response(ses, resp_buf);
>>
>>        /* now calculate the MAC key for NTLMv2 */
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 8c6a036..bec4ae7 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -128,8 +128,7 @@ cifs_read_super(struct super_block *sb, void *data,
>>
>>        if (rc) {
>>                if (!silent)
>> -                       cERROR(1,
>> -                              ("cifs_mount failed w/return code = %d", rc));
>> +                       cERROR(1, "cifs_mount failed w/return code = %d", rc);
>>                goto out_mount_failed;
>>        }
>>
>> @@ -160,7 +159,7 @@ cifs_read_super(struct super_block *sb, void *data,
>>
>>  #ifdef CONFIG_CIFS_EXPERIMENTAL
>>        if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
>> -               cFYI(1, ("export ops supported"));
>> +               cFYI(1, "export ops supported");
>>                sb->s_export_op = &cifs_export_ops;
>>        }
>>  #endif /* EXPERIMENTAL */
>> @@ -168,7 +167,7 @@ cifs_read_super(struct super_block *sb, void *data,
>>        return 0;
>>
>>  out_no_root:
>> -       cERROR(1, ("cifs_read_super: get root inode failed"));
>> +       cERROR(1, "cifs_read_super: get root inode failed");
>>        if (inode)
>>                iput(inode);
>>
>> @@ -194,10 +193,10 @@ cifs_put_super(struct super_block *sb)
>>        int rc = 0;
>>        struct cifs_sb_info *cifs_sb;
>>
>> -       cFYI(1, ("In cifs_put_super"));
>> +       cFYI(1, "In cifs_put_super");
>>        cifs_sb = CIFS_SB(sb);
>>        if (cifs_sb == NULL) {
>> -               cFYI(1, ("Empty cifs superblock info passed to unmount"));
>> +               cFYI(1, "Empty cifs superblock info passed to unmount");
>>                return;
>>        }
>>
>> @@ -205,7 +204,7 @@ cifs_put_super(struct super_block *sb)
>>
>>        rc = cifs_umount(sb, cifs_sb);
>>        if (rc)
>> -               cERROR(1, ("cifs_umount failed with return code %d", rc));
>> +               cERROR(1, "cifs_umount failed with return code %d", rc);
>>  #ifdef CONFIG_CIFS_DFS_UPCALL
>>        if (cifs_sb->mountdata) {
>>                kfree(cifs_sb->mountdata);
>> @@ -438,7 +437,7 @@ int cifs_xquota_set(struct super_block *sb, int quota_type, qid_t qid,
>>
>>        xid = GetXid();
>>        if (pTcon) {
>> -               cFYI(1, ("set type: 0x%x id: %d", quota_type, qid));
>> +               cFYI(1, "set type: 0x%x id: %d", quota_type, qid);
>>        } else
>>                rc = -EIO;
>>
>> @@ -461,7 +460,7 @@ int cifs_xquota_get(struct super_block *sb, int quota_type, qid_t qid,
>>
>>        xid = GetXid();
>>        if (pTcon) {
>> -               cFYI(1, ("set type: 0x%x id: %d", quota_type, qid));
>> +               cFYI(1, "set type: 0x%x id: %d", quota_type, qid);
>>        } else
>>                rc = -EIO;
>>
>> @@ -483,7 +482,7 @@ int cifs_xstate_set(struct super_block *sb, unsigned int flags, int operation)
>>
>>        xid = GetXid();
>>        if (pTcon) {
>> -               cFYI(1, ("flags: 0x%x operation: 0x%x", flags, operation));
>> +               cFYI(1, "flags: 0x%x operation: 0x%x", flags, operation);
>>        } else
>>                rc = -EIO;
>>
>> @@ -505,7 +504,7 @@ int cifs_xstate_get(struct super_block *sb, struct fs_quota_stat *qstats)
>>
>>        xid = GetXid();
>>        if (pTcon) {
>> -               cFYI(1, ("pqstats %p", qstats));
>> +               cFYI(1, "pqstats %p", qstats);
>>        } else
>>                rc = -EIO;
>>
>> @@ -547,7 +546,7 @@ static void cifs_umount_begin(struct super_block *sb)
>>        /* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
>>        /* cancel_notify_requests(tcon); */
>>        if (tcon->ses && tcon->ses->server) {
>> -               cFYI(1, ("wake up tasks now - umount begin not complete"));
>> +               cFYI(1, "wake up tasks now - umount begin not complete");
>>                wake_up_all(&tcon->ses->server->request_q);
>>                wake_up_all(&tcon->ses->server->response_q);
>>                msleep(1); /* yield */
>> @@ -598,7 +597,7 @@ cifs_get_sb(struct file_system_type *fs_type,
>>        int rc;
>>        struct super_block *sb = sget(fs_type, NULL, set_anon_super, NULL);
>>
>> -       cFYI(1, ("Devname: %s flags: %d ", dev_name, flags));
>> +       cFYI(1, "Devname: %s flags: %d ", dev_name, flags);
>>
>>        if (IS_ERR(sb))
>>                return PTR_ERR(sb);
>> @@ -866,7 +865,7 @@ cifs_init_request_bufs(void)
>>        } else {
>>                CIFSMaxBufSize &= 0x1FE00; /* Round size to even 512 byte mult*/
>>        }
>> -/*     cERROR(1,("CIFSMaxBufSize %d 0x%x",CIFSMaxBufSize,CIFSMaxBufSize)); */
>> +/*     cERROR(1, "CIFSMaxBufSize %d 0x%x",CIFSMaxBufSize,CIFSMaxBufSize); */
>>        cifs_req_cachep = kmem_cache_create("cifs_request",
>>                                            CIFSMaxBufSize +
>>                                            MAX_CIFS_HDR_SIZE, 0,
>> @@ -878,7 +877,7 @@ cifs_init_request_bufs(void)
>>                cifs_min_rcv = 1;
>>        else if (cifs_min_rcv > 64) {
>>                cifs_min_rcv = 64;
>> -               cERROR(1, ("cifs_min_rcv set to maximum (64)"));
>> +               cERROR(1, "cifs_min_rcv set to maximum (64)");
>>        }
>>
>>        cifs_req_poolp = mempool_create_slab_pool(cifs_min_rcv,
>> @@ -909,7 +908,7 @@ cifs_init_request_bufs(void)
>>                cifs_min_small = 2;
>>        else if (cifs_min_small > 256) {
>>                cifs_min_small = 256;
>> -               cFYI(1, ("cifs_min_small set to maximum (256)"));
>> +               cFYI(1, "cifs_min_small set to maximum (256)");
>>        }
>>
>>        cifs_sm_req_poolp = mempool_create_slab_pool(cifs_min_small,
>> @@ -1007,10 +1006,10 @@ init_cifs(void)
>>
>>        if (cifs_max_pending < 2) {
>>                cifs_max_pending = 2;
>> -               cFYI(1, ("cifs_max_pending set to min of 2"));
>> +               cFYI(1, "cifs_max_pending set to min of 2");
>>        } else if (cifs_max_pending > 256) {
>>                cifs_max_pending = 256;
>> -               cFYI(1, ("cifs_max_pending set to max of 256"));
>> +               cFYI(1, "cifs_max_pending set to max of 256");
>>        }
>>
>>        rc = cifs_init_inodecache();
>> @@ -1068,7 +1067,7 @@ init_cifs(void)
>>  static void __exit
>>  exit_cifs(void)
>>  {
>> -       cFYI(DBG2, ("exit_cifs"));
>> +       cFYI(DBG2, "exit_cifs");
>>        cifs_proc_clean();
>>  #ifdef CONFIG_CIFS_DFS_UPCALL
>>        cifs_dfs_release_automount_timer();
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 88e2bc4..d35d8f7 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -39,8 +39,20 @@ extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
>>                        unsigned int /* length */);
>>  extern unsigned int _GetXid(void);
>>  extern void _FreeXid(unsigned int);
>> -#define GetXid() (int)_GetXid(); cFYI(1,("CIFS VFS: in %s as Xid: %d with uid: %d",__func__, xid,current_fsuid()));
>> -#define FreeXid(curr_xid) {_FreeXid(curr_xid); cFYI(1,("CIFS VFS: leaving %s (xid = %d) rc = %d",__func__,curr_xid,(int)rc));}
>> +#define GetXid()                                               \
>> +({                                                             \
>> +       int __xid = (int)_GetXid();                             \
>> +       cFYI(1, "CIFS VFS: in %s as Xid: %d with uid: %d",      \
>> +            __func__, __xid, current_fsuid());                 \
>> +       __xid;                                                  \
>> +})
>> +
>> +#define FreeXid(curr_xid)                                      \
>> +do {                                                           \
>> +       _FreeXid(curr_xid);                                     \
>> +       cFYI(1, "CIFS VFS: leaving %s (xid = %d) rc = %d",      \
>> +            __func__, curr_xid, (int)rc);                      \
>> +} while (0)
>>  extern char *build_path_from_dentry(struct dentry *);
>>  extern char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb);
>>  extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 6118358..80371e6 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -129,8 +129,8 @@ cifs_reconnect_tcon(struct cifsTconInfo *tcon, int smb_command)
>>                if (smb_command != SMB_COM_WRITE_ANDX &&
>>                    smb_command != SMB_COM_OPEN_ANDX &&
>>                    smb_command != SMB_COM_TREE_DISCONNECT) {
>> -                       cFYI(1, ("can not send cmd %d while umounting",
>> -                               smb_command));
>> +                       cFYI(1, "can not send cmd %d while umounting",
>> +                               smb_command);
>>                        return -ENODEV;
>>                }
>>        }
>> @@ -156,7 +156,7 @@ cifs_reconnect_tcon(struct cifsTconInfo *tcon, int smb_command)
>>                 * back on-line
>>                 */
>>                if (!tcon->retry || ses->status == CifsExiting) {
>> -                       cFYI(1, ("gave up waiting on reconnect in smb_init"));
>> +                       cFYI(1, "gave up waiting on reconnect in smb_init");
>>                        return -EHOSTDOWN;
>>                }
>>        }
>> @@ -183,7 +183,7 @@ cifs_reconnect_tcon(struct cifsTconInfo *tcon, int smb_command)
>>        mark_open_files_invalid(tcon);
>>        rc = CIFSTCon(0, ses, tcon->treeName, tcon, nls_codepage);
>>        mutex_unlock(&ses->session_mutex);
>> -       cFYI(1, ("reconnect tcon rc = %d", rc));
>> +       cFYI(1, "reconnect tcon rc = %d", rc);
>>
>>        if (rc)
>>                goto out;
>> @@ -373,7 +373,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>>        else /* if override flags set only sign/seal OR them with global auth */
>>                secFlags = extended_security | ses->overrideSecFlg;
>>
>> -       cFYI(1, ("secFlags 0x%x", secFlags));
>> +       cFYI(1, "secFlags 0x%x", secFlags);
>>
>>        pSMB->hdr.Mid = GetNextMid(server);
>>        pSMB->hdr.Flags2 |= (SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS);
>> @@ -381,14 +381,14 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>>        if ((secFlags & CIFSSEC_MUST_KRB5) == CIFSSEC_MUST_KRB5)
>>                pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
>>        else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_KRB5) {
>> -               cFYI(1, ("Kerberos only mechanism, enable extended security"));
>> +               cFYI(1, "Kerberos only mechanism, enable extended security");
>>                pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
>>        }
>>  #ifdef CONFIG_CIFS_EXPERIMENTAL
>>        else if ((secFlags & CIFSSEC_MUST_NTLMSSP) == CIFSSEC_MUST_NTLMSSP)
>>                pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
>>        else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_NTLMSSP) {
>> -               cFYI(1, ("NTLMSSP only mechanism, enable extended security"));
>> +               cFYI(1, "NTLMSSP only mechanism, enable extended security");
>>                pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
>>        }
>>  #endif
>> @@ -408,7 +408,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>>                goto neg_err_exit;
>>
>>        dialect = le16_to_cpu(pSMBr->DialectIndex);
>> -       cFYI(1, ("Dialect: %d", dialect));
>> +       cFYI(1, "Dialect: %d", dialect);
>>        /* Check wct = 1 error case */
>>        if ((pSMBr->hdr.WordCount < 13) || (dialect == BAD_PROT)) {
>>                /* core returns wct = 1, but we do not ask for core - otherwise
>> @@ -427,8 +427,8 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>>                        (secFlags & CIFSSEC_MAY_PLNTXT))
>>                        server->secType = LANMAN;
>>                else {
>> -                       cERROR(1, ("mount failed weak security disabled"
>> -                                  " in /proc/fs/cifs/SecurityFlags"));
>> +                       cERROR(1, "mount failed weak security disabled"
>> +                                  " in /proc/fs/cifs/SecurityFlags");
>>                        rc = -EOPNOTSUPP;
>>                        goto neg_err_exit;
>>                }
>> @@ -461,9 +461,9 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>>                        utc = CURRENT_TIME;
>>                        ts = cnvrtDosUnixTm(rsp->SrvTime.Date,
>>                                            rsp->SrvTime.Time, 0);
>> -                       cFYI(1, ("SrvTime %d sec since 1970 (utc: %d) diff: %d",
>> +                       cFYI(1, "SrvTime %d sec since 1970 (utc: %d) diff: %d",
>>                                (int)ts.tv_sec, (int)utc.tv_sec,
>> -                               (int)(utc.tv_sec - ts.tv_sec)));
>> +                               (int)(utc.tv_sec - ts.tv_sec));
>>                        val = (int)(utc.tv_sec - ts.tv_sec);
>>                        seconds = abs(val);
>>                        result = (seconds / MIN_TZ_ADJ) * MIN_TZ_ADJ;
>> @@ -477,7 +477,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>>                        server->timeAdj = (int)tmp;
>>                        server->timeAdj *= 60; /* also in seconds */
>>                }
>> -               cFYI(1, ("server->timeAdj: %d seconds", server->timeAdj));
>> +               cFYI(1, "server->timeAdj: %d seconds", server->timeAdj);
>>
>>
>>                /* BB get server time for time conversions and add
>> @@ -492,14 +492,14 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>>                        goto neg_err_exit;
>>                }
>>
>> -               cFYI(1, ("LANMAN negotiated"));
>> +               cFYI(1, "LANMAN negotiated");
>>                /* we will not end up setting signing flags - as no signing
>>                was in LANMAN and server did not return the flags on */
>>                goto signing_check;
>>  #else /* weak security disabled */
>>        } else if (pSMBr->hdr.WordCount == 13) {
>> -               cERROR(1, ("mount failed, cifs module not built "
>> -                         "with CIFS_WEAK_PW_HASH support"));
>> +               cERROR(1, "mount failed, cifs module not built "
>> +                         "with CIFS_WEAK_PW_HASH support");
>>                        rc = -EOPNOTSUPP;
>>  #endif /* WEAK_PW_HASH */
>>                goto neg_err_exit;
>> @@ -511,14 +511,14 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>>        /* else wct == 17 NTLM */
>>        server->secMode = pSMBr->SecurityMode;
>>        if ((server->secMode & SECMODE_USER) == 0)
>> -               cFYI(1, ("share mode security"));
>> +               cFYI(1, "share mode security");
>>
>>        if ((server->secMode & SECMODE_PW_ENCRYPT) == 0)
>>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
>>                if ((secFlags & CIFSSEC_MAY_PLNTXT) == 0)
>>  #endif /* CIFS_WEAK_PW_HASH */
>> -                       cERROR(1, ("Server requests plain text password"
>> -                                 " but client support disabled"));
>> +                       cERROR(1, "Server requests plain text password"
>> +                                 " but client support disabled");
>>
>>        if ((secFlags & CIFSSEC_MUST_NTLMV2) == CIFSSEC_MUST_NTLMV2)
>>                server->secType = NTLMv2;
>> @@ -538,7 +538,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>>  #endif */
>>        else {
>>                rc = -EOPNOTSUPP;
>> -               cERROR(1, ("Invalid security type"));
>> +               cERROR(1, "Invalid security type");
>>                goto neg_err_exit;
>>        }
>>        /* else ... any others ...? */
>> @@ -550,7 +550,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>>        server->maxBuf = min(le32_to_cpu(pSMBr->MaxBufferSize),
>>                        (__u32) CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);
>>        server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
>> -       cFYI(DBG2, ("Max buf = %d", ses->server->maxBuf));
>> +       cFYI(DBG2, "Max buf = %d", ses->server->maxBuf);
>>        GETU32(ses->server->sessid) = le32_to_cpu(pSMBr->SessionKey);
>>        server->capabilities = le32_to_cpu(pSMBr->Capabilities);
>>        server->timeAdj = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
>> @@ -581,7 +581,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>>                        if (memcmp(server->server_GUID,
>>                                   pSMBr->u.extended_response.
>>                                   GUID, 16) != 0) {
>> -                               cFYI(1, ("server UID changed"));
>> +                               cFYI(1, "server UID changed");
>>                                memcpy(server->server_GUID,
>>                                        pSMBr->u.extended_response.GUID,
>>                                        16);
>> @@ -613,22 +613,21 @@ signing_check:
>>        if ((secFlags & CIFSSEC_MAY_SIGN) == 0) {
>>                /* MUST_SIGN already includes the MAY_SIGN FLAG
>>                   so if this is zero it means that signing is disabled */
>> -               cFYI(1, ("Signing disabled"));
>> +               cFYI(1, "Signing disabled");
>>                if (server->secMode & SECMODE_SIGN_REQUIRED) {
>> -                       cERROR(1, ("Server requires "
>> +                       cERROR(1, "Server requires "
>>                                   "packet signing to be enabled in "
>> -                                  "/proc/fs/cifs/SecurityFlags."));
>> +                                  "/proc/fs/cifs/SecurityFlags.");
>>                        rc = -EOPNOTSUPP;
>>                }
>>                server->secMode &=
>>                        ~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
>>        } else if ((secFlags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) {
>>                /* signing required */
>> -               cFYI(1, ("Must sign - secFlags 0x%x", secFlags));
>> +               cFYI(1, "Must sign - secFlags 0x%x", secFlags);
>>                if ((server->secMode &
>>                        (SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED)) == 0) {
>> -                       cERROR(1,
>> -                               ("signing required but server lacks support"));
>> +                       cERROR(1, "signing required but server lacks support");
>>                        rc = -EOPNOTSUPP;
>>                } else
>>                        server->secMode |= SECMODE_SIGN_REQUIRED;
>> @@ -642,7 +641,7 @@ signing_check:
>>  neg_err_exit:
>>        cifs_buf_release(pSMB);
>>
>> -       cFYI(1, ("negprot rc %d", rc));
>> +       cFYI(1, "negprot rc %d", rc);
>>        return rc;
>>  }
>>
>> @@ -652,7 +651,7 @@ CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon)
>>        struct smb_hdr *smb_buffer;
>>        int rc = 0;
>>
>> -       cFYI(1, ("In tree disconnect"));
>> +       cFYI(1, "In tree disconnect");
>>
>>        /* BB: do we need to check this? These should never be NULL. */
>>        if ((tcon->ses == NULL) || (tcon->ses->server == NULL))
>> @@ -674,7 +673,7 @@ CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon)
>>
>>        rc = SendReceiveNoRsp(xid, tcon->ses, smb_buffer, 0);
>>        if (rc)
>> -               cFYI(1, ("Tree disconnect failed %d", rc));
>> +               cFYI(1, "Tree disconnect failed %d", rc);
>>
>>        /* No need to return error on this operation if tid invalidated and
>>           closed on server already e.g. due to tcp session crashing */
>> @@ -690,7 +689,7 @@ CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses)
>>        LOGOFF_ANDX_REQ *pSMB;
>>        int rc = 0;
>>
>> -       cFYI(1, ("In SMBLogoff for session disconnect"));
>> +       cFYI(1, "In SMBLogoff for session disconnect");
>>
>>        /*
>>         * BB: do we need to check validity of ses and server? They should
>> @@ -743,7 +742,7 @@ CIFSPOSIXDelFile(const int xid, struct cifsTconInfo *tcon, const char *fileName,
>>        int bytes_returned = 0;
>>        __u16 params, param_offset, offset, byte_count;
>>
>> -       cFYI(1, ("In POSIX delete"));
>> +       cFYI(1, "In POSIX delete");
>>  PsxDelete:
>>        rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
>>                      (void **) &pSMBr);
>> @@ -795,7 +794,7 @@ PsxDelete:
>>        rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        if (rc)
>> -               cFYI(1, ("Posix delete returned %d", rc));
>> +               cFYI(1, "Posix delete returned %d", rc);
>>        cifs_buf_release(pSMB);
>>
>>        cifs_stats_inc(&tcon->num_deletes);
>> @@ -842,7 +841,7 @@ DelFileRetry:
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        cifs_stats_inc(&tcon->num_deletes);
>>        if (rc)
>> -               cFYI(1, ("Error in RMFile = %d", rc));
>> +               cFYI(1, "Error in RMFile = %d", rc);
>>
>>        cifs_buf_release(pSMB);
>>        if (rc == -EAGAIN)
>> @@ -861,7 +860,7 @@ CIFSSMBRmDir(const int xid, struct cifsTconInfo *tcon, const char *dirName,
>>        int bytes_returned;
>>        int name_len;
>>
>> -       cFYI(1, ("In CIFSSMBRmDir"));
>> +       cFYI(1, "In CIFSSMBRmDir");
>>  RmDirRetry:
>>        rc = smb_init(SMB_COM_DELETE_DIRECTORY, 0, tcon, (void **) &pSMB,
>>                      (void **) &pSMBr);
>> @@ -886,7 +885,7 @@ RmDirRetry:
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        cifs_stats_inc(&tcon->num_rmdirs);
>>        if (rc)
>> -               cFYI(1, ("Error in RMDir = %d", rc));
>> +               cFYI(1, "Error in RMDir = %d", rc);
>>
>>        cifs_buf_release(pSMB);
>>        if (rc == -EAGAIN)
>> @@ -904,7 +903,7 @@ CIFSSMBMkDir(const int xid, struct cifsTconInfo *tcon,
>>        int bytes_returned;
>>        int name_len;
>>
>> -       cFYI(1, ("In CIFSSMBMkDir"));
>> +       cFYI(1, "In CIFSSMBMkDir");
>>  MkDirRetry:
>>        rc = smb_init(SMB_COM_CREATE_DIRECTORY, 0, tcon, (void **) &pSMB,
>>                      (void **) &pSMBr);
>> @@ -929,7 +928,7 @@ MkDirRetry:
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        cifs_stats_inc(&tcon->num_mkdirs);
>>        if (rc)
>> -               cFYI(1, ("Error in Mkdir = %d", rc));
>> +               cFYI(1, "Error in Mkdir = %d", rc);
>>
>>        cifs_buf_release(pSMB);
>>        if (rc == -EAGAIN)
>> @@ -952,7 +951,7 @@ CIFSPOSIXCreate(const int xid, struct cifsTconInfo *tcon, __u32 posix_flags,
>>        OPEN_PSX_REQ *pdata;
>>        OPEN_PSX_RSP *psx_rsp;
>>
>> -       cFYI(1, ("In POSIX Create"));
>> +       cFYI(1, "In POSIX Create");
>>  PsxCreat:
>>        rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
>>                      (void **) &pSMBr);
>> @@ -1006,11 +1005,11 @@ PsxCreat:
>>        rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        if (rc) {
>> -               cFYI(1, ("Posix create returned %d", rc));
>> +               cFYI(1, "Posix create returned %d", rc);
>>                goto psx_create_err;
>>        }
>>
>> -       cFYI(1, ("copying inode info"));
>> +       cFYI(1, "copying inode info");
>>        rc = validate_t2((struct smb_t2_rsp *)pSMBr);
>>
>>        if (rc || (pSMBr->ByteCount < sizeof(OPEN_PSX_RSP))) {
>> @@ -1032,11 +1031,11 @@ PsxCreat:
>>        /* check to make sure response data is there */
>>        if (psx_rsp->ReturnedLevel != cpu_to_le16(SMB_QUERY_FILE_UNIX_BASIC)) {
>>                pRetData->Type = cpu_to_le32(-1); /* unknown */
>> -               cFYI(DBG2, ("unknown type"));
>> +               cFYI(DBG2, "unknown type");
>>        } else {
>>                if (pSMBr->ByteCount < sizeof(OPEN_PSX_RSP)
>>                                        + sizeof(FILE_UNIX_BASIC_INFO)) {
>> -                       cERROR(1, ("Open response data too small"));
>> +                       cERROR(1, "Open response data too small");
>>                        pRetData->Type = cpu_to_le32(-1);
>>                        goto psx_create_err;
>>                }
>> @@ -1083,7 +1082,7 @@ static __u16 convert_disposition(int disposition)
>>                        ofun = SMBOPEN_OCREATE | SMBOPEN_OTRUNC;
>>                        break;
>>                default:
>> -                       cFYI(1, ("unknown disposition %d", disposition));
>> +                       cFYI(1, "unknown disposition %d", disposition);
>>                        ofun =  SMBOPEN_OAPPEND; /* regular open */
>>        }
>>        return ofun;
>> @@ -1174,7 +1173,7 @@ OldOpenRetry:
>>                        (struct smb_hdr *)pSMBr, &bytes_returned, CIFS_LONG_OP);
>>        cifs_stats_inc(&tcon->num_opens);
>>        if (rc) {
>> -               cFYI(1, ("Error in Open = %d", rc));
>> +               cFYI(1, "Error in Open = %d", rc);
>>        } else {
>>        /* BB verify if wct == 15 */
>>
>> @@ -1287,7 +1286,7 @@ openRetry:
>>                        (struct smb_hdr *)pSMBr, &bytes_returned, CIFS_LONG_OP);
>>        cifs_stats_inc(&tcon->num_opens);
>>        if (rc) {
>> -               cFYI(1, ("Error in Open = %d", rc));
>> +               cFYI(1, "Error in Open = %d", rc);
>>        } else {
>>                *pOplock = pSMBr->OplockLevel; /* 1 byte no need to le_to_cpu */
>>                *netfid = pSMBr->Fid;   /* cifs fid stays in le */
>> @@ -1325,7 +1324,7 @@ CIFSSMBRead(const int xid, struct cifsTconInfo *tcon, const int netfid,
>>        int resp_buf_type = 0;
>>        struct kvec iov[1];
>>
>> -       cFYI(1, ("Reading %d bytes on fid %d", count, netfid));
>> +       cFYI(1, "Reading %d bytes on fid %d", count, netfid);
>>        if (tcon->ses->capabilities & CAP_LARGE_FILES)
>>                wct = 12;
>>        else {
>> @@ -1370,7 +1369,7 @@ CIFSSMBRead(const int xid, struct cifsTconInfo *tcon, const int netfid,
>>        cifs_stats_inc(&tcon->num_reads);
>>        pSMBr = (READ_RSP *)iov[0].iov_base;
>>        if (rc) {
>> -               cERROR(1, ("Send error in read = %d", rc));
>> +               cERROR(1, "Send error in read = %d", rc);
>>        } else {
>>                int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
>>                data_length = data_length << 16;
>> @@ -1380,15 +1379,15 @@ CIFSSMBRead(const int xid, struct cifsTconInfo *tcon, const int netfid,
>>                /*check that DataLength would not go beyond end of SMB */
>>                if ((data_length > CIFSMaxBufSize)
>>                                || (data_length > count)) {
>> -                       cFYI(1, ("bad length %d for count %d",
>> -                                data_length, count));
>> +                       cFYI(1, "bad length %d for count %d",
>> +                                data_length, count);
>>                        rc = -EIO;
>>                        *nbytes = 0;
>>                } else {
>>                        pReadData = (char *) (&pSMBr->hdr.Protocol) +
>>                                        le16_to_cpu(pSMBr->DataOffset);
>>  /*                     if (rc = copy_to_user(buf, pReadData, data_length)) {
>> -                               cERROR(1,("Faulting on read rc = %d",rc));
>> +                               cERROR(1, "Faulting on read rc = %d",rc);
>>                                rc = -EFAULT;
>>                        }*/ /* can not use copy_to_user when using page cache*/
>>                        if (*buf)
>> @@ -1430,7 +1429,7 @@ CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
>>        __u32 bytes_sent;
>>        __u16 byte_count;
>>
>> -       /* cFYI(1, ("write at %lld %d bytes", offset, count));*/
>> +       /* cFYI(1, "write at %lld %d bytes", offset, count);*/
>>        if (tcon->ses == NULL)
>>                return -ECONNABORTED;
>>
>> @@ -1511,7 +1510,7 @@ CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, long_op);
>>        cifs_stats_inc(&tcon->num_writes);
>>        if (rc) {
>> -               cFYI(1, ("Send error in write = %d", rc));
>> +               cFYI(1, "Send error in write = %d", rc);
>>                *nbytes = 0;
>>        } else {
>>                *nbytes = le16_to_cpu(pSMBr->CountHigh);
>> @@ -1541,7 +1540,7 @@ CIFSSMBWrite2(const int xid, struct cifsTconInfo *tcon,
>>
>>        *nbytes = 0;
>>
>> -       cFYI(1, ("write2 at %lld %d bytes", (long long)offset, count));
>> +       cFYI(1, "write2 at %lld %d bytes", (long long)offset, count);
>>
>>        if (tcon->ses->capabilities & CAP_LARGE_FILES) {
>>                wct = 14;
>> @@ -1596,7 +1595,7 @@ CIFSSMBWrite2(const int xid, struct cifsTconInfo *tcon,
>>                          long_op);
>>        cifs_stats_inc(&tcon->num_writes);
>>        if (rc) {
>> -               cFYI(1, ("Send error Write2 = %d", rc));
>> +               cFYI(1, "Send error Write2 = %d", rc);
>>        } else if (resp_buf_type == 0) {
>>                /* presumably this can not happen, but best to be safe */
>>                rc = -EIO;
>> @@ -1633,7 +1632,7 @@ CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
>>        int timeout = 0;
>>        __u16 count;
>>
>> -       cFYI(1, ("CIFSSMBLock timeout %d numLock %d", (int)waitFlag, numLock));
>> +       cFYI(1, "CIFSSMBLock timeout %d numLock %d", (int)waitFlag, numLock);
>>        rc = small_smb_init(SMB_COM_LOCKING_ANDX, 8, tcon, (void **) &pSMB);
>>
>>        if (rc)
>> @@ -1681,7 +1680,7 @@ CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
>>        }
>>        cifs_stats_inc(&tcon->num_locks);
>>        if (rc)
>> -               cFYI(1, ("Send error in Lock = %d", rc));
>> +               cFYI(1, "Send error in Lock = %d", rc);
>>
>>        /* Note: On -EAGAIN error only caller can retry on handle based calls
>>        since file handle passed in no longer valid */
>> @@ -1704,7 +1703,7 @@ CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
>>        __u16 params, param_offset, offset, byte_count, count;
>>        struct kvec iov[1];
>>
>> -       cFYI(1, ("Posix Lock"));
>> +       cFYI(1, "Posix Lock");
>>
>>        if (pLockData == NULL)
>>                return -EINVAL;
>> @@ -1774,7 +1773,7 @@ CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
>>        }
>>
>>        if (rc) {
>> -               cFYI(1, ("Send error in Posix Lock = %d", rc));
>> +               cFYI(1, "Send error in Posix Lock = %d", rc);
>>        } else if (get_flag) {
>>                /* lock structure can be returned on get */
>>                __u16 data_offset;
>> @@ -1818,7 +1817,7 @@ CIFSSMBClose(const int xid, struct cifsTconInfo *tcon, int smb_file_id)
>>  {
>>        int rc = 0;
>>        CLOSE_REQ *pSMB = NULL;
>> -       cFYI(1, ("In CIFSSMBClose"));
>> +       cFYI(1, "In CIFSSMBClose");
>>
>>  /* do not retry on dead session on close */
>>        rc = small_smb_init(SMB_COM_CLOSE, 3, tcon, (void **) &pSMB);
>> @@ -1835,7 +1834,7 @@ CIFSSMBClose(const int xid, struct cifsTconInfo *tcon, int smb_file_id)
>>        if (rc) {
>>                if (rc != -EINTR) {
>>                        /* EINTR is expected when user ctl-c to kill app */
>> -                       cERROR(1, ("Send error in Close = %d", rc));
>> +                       cERROR(1, "Send error in Close = %d", rc);
>>                }
>>        }
>>
>> @@ -1851,7 +1850,7 @@ CIFSSMBFlush(const int xid, struct cifsTconInfo *tcon, int smb_file_id)
>>  {
>>        int rc = 0;
>>        FLUSH_REQ *pSMB = NULL;
>> -       cFYI(1, ("In CIFSSMBFlush"));
>> +       cFYI(1, "In CIFSSMBFlush");
>>
>>        rc = small_smb_init(SMB_COM_FLUSH, 1, tcon, (void **) &pSMB);
>>        if (rc)
>> @@ -1862,7 +1861,7 @@ CIFSSMBFlush(const int xid, struct cifsTconInfo *tcon, int smb_file_id)
>>        rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
>>        cifs_stats_inc(&tcon->num_flushes);
>>        if (rc)
>> -               cERROR(1, ("Send error in Flush = %d", rc));
>> +               cERROR(1, "Send error in Flush = %d", rc);
>>
>>        return rc;
>>  }
>> @@ -1879,7 +1878,7 @@ CIFSSMBRename(const int xid, struct cifsTconInfo *tcon,
>>        int name_len, name_len2;
>>        __u16 count;
>>
>> -       cFYI(1, ("In CIFSSMBRename"));
>> +       cFYI(1, "In CIFSSMBRename");
>>  renameRetry:
>>        rc = smb_init(SMB_COM_RENAME, 1, tcon, (void **) &pSMB,
>>                      (void **) &pSMBr);
>> @@ -1925,7 +1924,7 @@ renameRetry:
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        cifs_stats_inc(&tcon->num_renames);
>>        if (rc)
>> -               cFYI(1, ("Send error in rename = %d", rc));
>> +               cFYI(1, "Send error in rename = %d", rc);
>>
>>        cifs_buf_release(pSMB);
>>
>> @@ -1949,7 +1948,7 @@ int CIFSSMBRenameOpenFile(const int xid, struct cifsTconInfo *pTcon,
>>        int len_of_str;
>>        __u16 params, param_offset, offset, count, byte_count;
>>
>> -       cFYI(1, ("Rename to File by handle"));
>> +       cFYI(1, "Rename to File by handle");
>>        rc = smb_init(SMB_COM_TRANSACTION2, 15, pTcon, (void **) &pSMB,
>>                        (void **) &pSMBr);
>>        if (rc)
>> @@ -2004,7 +2003,7 @@ int CIFSSMBRenameOpenFile(const int xid, struct cifsTconInfo *pTcon,
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        cifs_stats_inc(&pTcon->num_t2renames);
>>        if (rc)
>> -               cFYI(1, ("Send error in Rename (by file handle) = %d", rc));
>> +               cFYI(1, "Send error in Rename (by file handle) = %d", rc);
>>
>>        cifs_buf_release(pSMB);
>>
>> @@ -2026,7 +2025,7 @@ CIFSSMBCopy(const int xid, struct cifsTconInfo *tcon, const char *fromName,
>>        int name_len, name_len2;
>>        __u16 count;
>>
>> -       cFYI(1, ("In CIFSSMBCopy"));
>> +       cFYI(1, "In CIFSSMBCopy");
>>  copyRetry:
>>        rc = smb_init(SMB_COM_COPY, 1, tcon, (void **) &pSMB,
>>                        (void **) &pSMBr);
>> @@ -2071,8 +2070,8 @@ copyRetry:
>>        rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>>                (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        if (rc) {
>> -               cFYI(1, ("Send error in copy = %d with %d files copied",
>> -                       rc, le16_to_cpu(pSMBr->CopyCount)));
>> +               cFYI(1, "Send error in copy = %d with %d files copied",
>> +                       rc, le16_to_cpu(pSMBr->CopyCount));
>>        }
>>        cifs_buf_release(pSMB);
>>
>> @@ -2096,7 +2095,7 @@ CIFSUnixCreateSymLink(const int xid, struct cifsTconInfo *tcon,
>>        int bytes_returned = 0;
>>        __u16 params, param_offset, offset, byte_count;
>>
>> -       cFYI(1, ("In Symlink Unix style"));
>> +       cFYI(1, "In Symlink Unix style");
>>  createSymLinkRetry:
>>        rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
>>                      (void **) &pSMBr);
>> @@ -2161,7 +2160,7 @@ createSymLinkRetry:
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        cifs_stats_inc(&tcon->num_symlinks);
>>        if (rc)
>> -               cFYI(1, ("Send error in SetPathInfo create symlink = %d", rc));
>> +               cFYI(1, "Send error in SetPathInfo create symlink = %d", rc);
>>
>>        cifs_buf_release(pSMB);
>>
>> @@ -2185,7 +2184,7 @@ CIFSUnixCreateHardLink(const int xid, struct cifsTconInfo *tcon,
>>        int bytes_returned = 0;
>>        __u16 params, param_offset, offset, byte_count;
>>
>> -       cFYI(1, ("In Create Hard link Unix style"));
>> +       cFYI(1, "In Create Hard link Unix style");
>>  createHardLinkRetry:
>>        rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
>>                      (void **) &pSMBr);
>> @@ -2247,7 +2246,7 @@ createHardLinkRetry:
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        cifs_stats_inc(&tcon->num_hardlinks);
>>        if (rc)
>> -               cFYI(1, ("Send error in SetPathInfo (hard link) = %d", rc));
>> +               cFYI(1, "Send error in SetPathInfo (hard link) = %d", rc);
>>
>>        cifs_buf_release(pSMB);
>>        if (rc == -EAGAIN)
>> @@ -2268,7 +2267,7 @@ CIFSCreateHardLink(const int xid, struct cifsTconInfo *tcon,
>>        int name_len, name_len2;
>>        __u16 count;
>>
>> -       cFYI(1, ("In CIFSCreateHardLink"));
>> +       cFYI(1, "In CIFSCreateHardLink");
>>  winCreateHardLinkRetry:
>>
>>        rc = smb_init(SMB_COM_NT_RENAME, 4, tcon, (void **) &pSMB,
>> @@ -2319,7 +2318,7 @@ winCreateHardLinkRetry:
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        cifs_stats_inc(&tcon->num_hardlinks);
>>        if (rc)
>> -               cFYI(1, ("Send error in hard link (NT rename) = %d", rc));
>> +               cFYI(1, "Send error in hard link (NT rename) = %d", rc);
>>
>>        cifs_buf_release(pSMB);
>>        if (rc == -EAGAIN)
>> @@ -2342,7 +2341,7 @@ CIFSSMBUnixQuerySymLink(const int xid, struct cifsTconInfo *tcon,
>>        __u16 params, byte_count;
>>        char *data_start;
>>
>> -       cFYI(1, ("In QPathSymLinkInfo (Unix) for path %s", searchName));
>> +       cFYI(1, "In QPathSymLinkInfo (Unix) for path %s", searchName);
>>
>>  querySymLinkRetry:
>>        rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
>> @@ -2389,7 +2388,7 @@ querySymLinkRetry:
>>        rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        if (rc) {
>> -               cFYI(1, ("Send error in QuerySymLinkInfo = %d", rc));
>> +               cFYI(1, "Send error in QuerySymLinkInfo = %d", rc);
>>        } else {
>>                /* decode response */
>>
>> @@ -2490,21 +2489,21 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
>>
>>        /* should we also check that parm and data areas do not overlap? */
>>        if (*ppparm > end_of_smb) {
>> -               cFYI(1, ("parms start after end of smb"));
>> +               cFYI(1, "parms start after end of smb");
>>                return -EINVAL;
>>        } else if (parm_count + *ppparm > end_of_smb) {
>> -               cFYI(1, ("parm end after end of smb"));
>> +               cFYI(1, "parm end after end of smb");
>>                return -EINVAL;
>>        } else if (*ppdata > end_of_smb) {
>> -               cFYI(1, ("data starts after end of smb"));
>> +               cFYI(1, "data starts after end of smb");
>>                return -EINVAL;
>>        } else if (data_count + *ppdata > end_of_smb) {
>> -               cFYI(1, ("data %p + count %d (%p) ends after end of smb %p start %p",
>> +               cFYI(1, "data %p + count %d (%p) ends after end of smb %p start %p",
>>                        *ppdata, data_count, (data_count + *ppdata),
>> -                       end_of_smb, pSMBr));
>> +                       end_of_smb, pSMBr);
>>                return -EINVAL;
>>        } else if (parm_count + data_count > pSMBr->ByteCount) {
>> -               cFYI(1, ("parm count and data count larger than SMB"));
>> +               cFYI(1, "parm count and data count larger than SMB");
>>                return -EINVAL;
>>        }
>>        *pdatalen = data_count;
>> @@ -2523,7 +2522,7 @@ CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
>>        struct smb_com_transaction_ioctl_req *pSMB;
>>        struct smb_com_transaction_ioctl_rsp *pSMBr;
>>
>> -       cFYI(1, ("In Windows reparse style QueryLink for path %s", searchName));
>> +       cFYI(1, "In Windows reparse style QueryLink for path %s", searchName);
>>        rc = smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **) &pSMB,
>>                      (void **) &pSMBr);
>>        if (rc)
>> @@ -2552,7 +2551,7 @@ CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
>>        rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        if (rc) {
>> -               cFYI(1, ("Send error in QueryReparseLinkInfo = %d", rc));
>> +               cFYI(1, "Send error in QueryReparseLinkInfo = %d", rc);
>>        } else {                /* decode response */
>>                __u32 data_offset = le32_to_cpu(pSMBr->DataOffset);
>>                __u32 data_count = le32_to_cpu(pSMBr->DataCount);
>> @@ -2576,7 +2575,7 @@ CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
>>                        if ((reparse_buf->LinkNamesBuf +
>>                                reparse_buf->TargetNameOffset +
>>                                reparse_buf->TargetNameLen) > end_of_smb) {
>> -                               cFYI(1, ("reparse buf beyond SMB"));
>> +                               cFYI(1, "reparse buf beyond SMB");
>>                                rc = -EIO;
>>                                goto qreparse_out;
>>                        }
>> @@ -2597,12 +2596,12 @@ CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
>>                        }
>>                } else {
>>                        rc = -EIO;
>> -                       cFYI(1, ("Invalid return data count on "
>> -                                "get reparse info ioctl"));
>> +                       cFYI(1, "Invalid return data count on "
>> +                                "get reparse info ioctl");
>>                }
>>                symlinkinfo[buflen] = 0; /* just in case so the caller
>>                                        does not go off the end of the buffer */
>> -               cFYI(1, ("readlink result - %s", symlinkinfo));
>> +               cFYI(1, "readlink result - %s", symlinkinfo);
>>        }
>>
>>  qreparse_out:
>> @@ -2625,7 +2624,7 @@ static void cifs_convert_ace(posix_acl_xattr_entry *ace,
>>        ace->e_perm = cpu_to_le16(cifs_ace->cifs_e_perm);
>>        ace->e_tag  = cpu_to_le16(cifs_ace->cifs_e_tag);
>>        ace->e_id   = cpu_to_le32(le64_to_cpu(cifs_ace->cifs_uid));
>> -       /* cFYI(1,("perm %d tag %d id %d",ace->e_perm,ace->e_tag,ace->e_id)); */
>> +       /* cFYI(1, "perm %d tag %d id %d",ace->e_perm,ace->e_tag,ace->e_id); */
>>
>>        return;
>>  }
>> @@ -2651,8 +2650,8 @@ static int cifs_copy_posix_acl(char *trgt, char *src, const int buflen,
>>                size += sizeof(struct cifs_posix_ace) * count;
>>                /* check if we would go beyond end of SMB */
>>                if (size_of_data_area < size) {
>> -                       cFYI(1, ("bad CIFS POSIX ACL size %d vs. %d",
>> -                               size_of_data_area, size));
>> +                       cFYI(1, "bad CIFS POSIX ACL size %d vs. %d",
>> +                               size_of_data_area, size);
>>                        return -EINVAL;
>>                }
>>        } else if (acl_type & ACL_TYPE_DEFAULT) {
>> @@ -2699,7 +2698,7 @@ static __u16 convert_ace_to_cifs_ace(struct cifs_posix_ace *cifs_ace,
>>                cifs_ace->cifs_uid = cpu_to_le64(-1);
>>        } else
>>                cifs_ace->cifs_uid = cpu_to_le64(le32_to_cpu(local_ace->e_id));
>> -       /*cFYI(1,("perm %d tag %d id %d",ace->e_perm,ace->e_tag,ace->e_id));*/
>> +       /*cFYI(1, "perm %d tag %d id %d",ace->e_perm,ace->e_tag,ace->e_id);*/
>>        return rc;
>>  }
>>
>> @@ -2717,12 +2716,12 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
>>                return 0;
>>
>>        count = posix_acl_xattr_count((size_t)buflen);
>> -       cFYI(1, ("setting acl with %d entries from buf of length %d and "
>> +       cFYI(1, "setting acl with %d entries from buf of length %d and "
>>                "version of %d",
>> -               count, buflen, le32_to_cpu(local_acl->a_version)));
>> +               count, buflen, le32_to_cpu(local_acl->a_version));
>>        if (le32_to_cpu(local_acl->a_version) != 2) {
>> -               cFYI(1, ("unknown POSIX ACL version %d",
>> -                    le32_to_cpu(local_acl->a_version)));
>> +               cFYI(1, "unknown POSIX ACL version %d",
>> +                    le32_to_cpu(local_acl->a_version));
>>                return 0;
>>        }
>>        cifs_acl->version = cpu_to_le16(1);
>> @@ -2731,7 +2730,7 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
>>        else if (acl_type == ACL_TYPE_DEFAULT)
>>                cifs_acl->default_entry_count = cpu_to_le16(count);
>>        else {
>> -               cFYI(1, ("unknown ACL type %d", acl_type));
>> +               cFYI(1, "unknown ACL type %d", acl_type);
>>                return 0;
>>        }
>>        for (i = 0; i < count; i++) {
>> @@ -2764,7 +2763,7 @@ CIFSSMBGetPosixACL(const int xid, struct cifsTconInfo *tcon,
>>        int name_len;
>>        __u16 params, byte_count;
>>
>> -       cFYI(1, ("In GetPosixACL (Unix) for path %s", searchName));
>> +       cFYI(1, "In GetPosixACL (Unix) for path %s", searchName);
>>
>>  queryAclRetry:
>>        rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
>> @@ -2816,7 +2815,7 @@ queryAclRetry:
>>                (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        cifs_stats_inc(&tcon->num_acl_get);
>>        if (rc) {
>> -               cFYI(1, ("Send error in Query POSIX ACL = %d", rc));
>> +               cFYI(1, "Send error in Query POSIX ACL = %d", rc);
>>        } else {
>>                /* decode response */
>>
>> @@ -2853,7 +2852,7 @@ CIFSSMBSetPosixACL(const int xid, struct cifsTconInfo *tcon,
>>        int bytes_returned = 0;
>>        __u16 params, byte_count, data_count, param_offset, offset;
>>
>> -       cFYI(1, ("In SetPosixACL (Unix) for path %s", fileName));
>> +       cFYI(1, "In SetPosixACL (Unix) for path %s", fileName);
>>  setAclRetry:
>>        rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
>>                      (void **) &pSMBr);
>> @@ -2908,7 +2907,7 @@ setAclRetry:
>>        rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        if (rc)
>> -               cFYI(1, ("Set POSIX ACL returned %d", rc));
>> +               cFYI(1, "Set POSIX ACL returned %d", rc);
>>
>>  setACLerrorExit:
>>        cifs_buf_release(pSMB);
>> @@ -2928,7 +2927,7 @@ CIFSGetExtAttr(const int xid, struct cifsTconInfo *tcon,
>>        int bytes_returned;
>>        __u16 params, byte_count;
>>
>> -       cFYI(1, ("In GetExtAttr"));
>> +       cFYI(1, "In GetExtAttr");
>>        if (tcon == NULL)
>>                return -ENODEV;
>>
>> @@ -2967,7 +2966,7 @@ GetExtAttrRetry:
>>        rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        if (rc) {
>> -               cFYI(1, ("error %d in GetExtAttr", rc));
>> +               cFYI(1, "error %d in GetExtAttr", rc);
>>        } else {
>>                /* decode response */
>>                rc = validate_t2((struct smb_t2_rsp *)pSMBr);
>> @@ -2982,7 +2981,7 @@ GetExtAttrRetry:
>>                        struct file_chattr_info *pfinfo;
>>                        /* BB Do we need a cast or hash here ? */
>>                        if (count != 16) {
>> -                               cFYI(1, ("Illegal size ret in GetExtAttr"));
>> +                               cFYI(1, "Illegal size ret in GetExtAttr");
>>                                rc = -EIO;
>>                                goto GetExtAttrOut;
>>                        }
>> @@ -3012,7 +3011,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
>>        QUERY_SEC_DESC_REQ *pSMB;
>>        struct kvec iov[1];
>>
>> -       cFYI(1, ("GetCifsACL"));
>> +       cFYI(1, "GetCifsACL");
>>
>>        *pbuflen = 0;
>>        *acl_inf = NULL;
>> @@ -3037,7 +3036,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
>>                         CIFS_STD_OP);
>>        cifs_stats_inc(&tcon->num_acl_get);
>>        if (rc) {
>> -               cFYI(1, ("Send error in QuerySecDesc = %d", rc));
>> +               cFYI(1, "Send error in QuerySecDesc = %d", rc);
>>        } else {                /* decode response */
>>                __le32 *parm;
>>                __u32 parm_len;
>> @@ -3052,7 +3051,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
>>                        goto qsec_out;
>>                pSMBr = (struct smb_com_ntransact_rsp *)iov[0].iov_base;
>>
>> -               cFYI(1, ("smb %p parm %p data %p", pSMBr, parm, *acl_inf));
>> +               cFYI(1, "smb %p parm %p data %p", pSMBr, parm, *acl_inf);
>>
>>                if (le32_to_cpu(pSMBr->ParameterCount) != 4) {
>>                        rc = -EIO;      /* bad smb */
>> @@ -3064,8 +3063,8 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
>>
>>                acl_len = le32_to_cpu(*parm);
>>                if (acl_len != *pbuflen) {
>> -                       cERROR(1, ("acl length %d does not match %d",
>> -                                  acl_len, *pbuflen));
>> +                       cERROR(1, "acl length %d does not match %d",
>> +                                  acl_len, *pbuflen);
>>                        if (*pbuflen > acl_len)
>>                                *pbuflen = acl_len;
>>                }
>> @@ -3074,7 +3073,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
>>                   header followed by the smallest SID */
>>                if ((*pbuflen < sizeof(struct cifs_ntsd) + 8) ||
>>                    (*pbuflen >= 64 * 1024)) {
>> -                       cERROR(1, ("bad acl length %d", *pbuflen));
>> +                       cERROR(1, "bad acl length %d", *pbuflen);
>>                        rc = -EINVAL;
>>                        *pbuflen = 0;
>>                } else {
>> @@ -3148,9 +3147,9 @@ setCifsAclRetry:
>>        rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>>                (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>
>> -       cFYI(1, ("SetCIFSACL bytes_returned: %d, rc: %d", bytes_returned, rc));
>> +       cFYI(1, "SetCIFSACL bytes_returned: %d, rc: %d", bytes_returned, rc);
>>        if (rc)
>> -               cFYI(1, ("Set CIFS ACL returned %d", rc));
>> +               cFYI(1, "Set CIFS ACL returned %d", rc);
>>        cifs_buf_release(pSMB);
>>
>>        if (rc == -EAGAIN)
>> @@ -3174,7 +3173,7 @@ int SMBQueryInformation(const int xid, struct cifsTconInfo *tcon,
>>        int bytes_returned;
>>        int name_len;
>>
>> -       cFYI(1, ("In SMBQPath path %s", searchName));
>> +       cFYI(1, "In SMBQPath path %s", searchName);
>>  QInfRetry:
>>        rc = smb_init(SMB_COM_QUERY_INFORMATION, 0, tcon, (void **) &pSMB,
>>                      (void **) &pSMBr);
>> @@ -3200,7 +3199,7 @@ QInfRetry:
>>        rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        if (rc) {
>> -               cFYI(1, ("Send error in QueryInfo = %d", rc));
>> +               cFYI(1, "Send error in QueryInfo = %d", rc);
>>        } else if (pFinfo) {
>>                struct timespec ts;
>>                __u32 time = le32_to_cpu(pSMBr->last_write_time);
>> @@ -3248,7 +3247,7 @@ CIFSSMBQPathInfo(const int xid, struct cifsTconInfo *tcon,
>>        int name_len;
>>        __u16 params, byte_count;
>>
>> -/* cFYI(1, ("In QPathInfo path %s", searchName)); */
>> +/* cFYI(1, "In QPathInfo path %s", searchName); */
>>  QPathInfoRetry:
>>        rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
>>                      (void **) &pSMBr);
>> @@ -3298,7 +3297,7 @@ QPathInfoRetry:
>>        rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        if (rc) {
>> -               cFYI(1, ("Send error in QPathInfo = %d", rc));
>> +               cFYI(1, "Send error in QPathInfo = %d", rc);
>>        } else {                /* decode response */
>>                rc = validate_t2((struct smb_t2_rsp *)pSMBr);
>>
>> @@ -3348,7 +3347,7 @@ CIFSSMBUnixQPathInfo(const int xid, struct cifsTconInfo *tcon,
>>        int name_len;
>>        __u16 params, byte_count;
>>
>> -       cFYI(1, ("In QPathInfo (Unix) the path %s", searchName));
>> +       cFYI(1, "In QPathInfo (Unix) the path %s", searchName);
>>  UnixQPathInfoRetry:
>>        rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
>>                      (void **) &pSMBr);
>> @@ -3395,14 +3394,14 @@ UnixQPathInfoRetry:
>>        rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>>                         (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>        if (rc) {
>> -               cFYI(1, ("Send error in QPathInfo = %d", rc));
>> +               cFYI(1, "Send error in QPathInfo = %d", rc);
>>        } else {                /* decode response */
>>                rc = validate_t2((struct smb_t2_rsp *)pSMBr);
>>
>>                if (rc || (pSMBr->ByteCount < sizeof(FILE_UNIX_BASIC_INFO))) {
>> -                       cERROR(1, ("Malformed FILE_UNIX_BASIC_INFO response.\n"
>> +                       cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response.\n"
>>                                   "Unix Extensions can be disabled on mount "
>> -                                  "by specifying the nosfu mount option."));
>> +                                  "by specifying the nosfu mount option.");
>>                        rc = -EIO;      /* bad smb */
>>                } else {
>>                        __u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
>> @@ -3436,7 +3435,7 @@ CIFSFindFirst(const int xid, struct cifsTconInfo *tcon,
>>        int name_len;
>>        __u16 params, byte_count;
>>
>> -       cFYI(1, ("In FindFirst for %s", searchName));
>> +       cFYI(1, "In FindFirst for %s", searchName);
>>
>>  findFirstRetry:
>>        rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
>> @@ -3513,7 +3512,7 @@ findFirstRetry:
>>        if (rc) {/* BB add logic to retry regular search if Unix search
>>                        rejected unexpectedly by server */
>>                /* BB Add code to handle unsupported level rc */
>> -               cFYI(1, ("Error in FindFirst = %d", rc));
>> +               cFYI(1, "Error in FindFirst = %d", rc);
>>
>>                cifs_buf_release(pSMB);
>>
>> @@ -3552,7 +3551,7 @@ findFirstRetry:
>>                        lnoff = le16_to_cpu(parms->LastNameOffset);
>>                        if (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE <
>>                              lnoff) {
>> -                               cERROR(1, ("ignoring corrupt resume name"));
>> +                               cERROR(1, "ignoring corrupt resume name");
>>                                psrch_inf->last_entry = NULL;
>>                                return rc;
>>                        }
>> @@ -3580,7 +3579,7 @@ int CIFSFindNext(const int xid, struct cifsTconInfo *tcon,
>>        int bytes_returned, name_len;
>>        __u16 params, byte_count;
>>
>> -       cFYI(1, ("In FindNext"));
>> +       cFYI(1, "In FindNext");
>>
>>        if (psrch_inf->endOfSearch)
>>                return -ENOENT;
>> @@ -3644,7 +3643,7 @@ int CIFSFindNext(const int xid, struct cifsTconInfo *tcon,
>>                        cifs_buf_release(pSMB);
>>                        rc = 0; /* search probably was closed at end of search*/
>>                } else
>> -                       cFYI(1, ("FindNext returned = %d", rc));
>> +                       cFYI(1, "FindNext returned = %d", rc);
>>



-- 
Thanks,

Steve
