Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab1JATG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:06:29 -0400
Received: from 1wt.eu ([62.212.114.60]:33336 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab1JATGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:06:21 -0400
Date: Sat, 1 Oct 2011 21:06:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andy <akwatts@ymail.com>
Cc: schwab@linux-m68k.org, Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
Message-ID: <20111001190612.GA14779@1wt.eu>
References: <4E8655CD.90107@zytor.com> <20110930235924.GA25176@kroah.com> <20111001141751.GA8937@zeus> <20111001142848.GA27058@kroah.com> <20111001165659.GB18690@1wt.eu> <20111001171916.GA11989@zeus> <20111001175456.GC18690@1wt.eu> <20111001184044.GA13608@zeus>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20111001184044.GA13608@zeus>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 01, 2011 at 01:40:44PM -0500, Andy wrote:
> On Sat, Oct 01, 2011 at 07:54:56PM +0200, Willy Tarreau wrote:
> >   $ git config tar.umask 022
> 
> Andreas/Willy:
> 
> It was indeed umask which was skewing the results. Thanks.
> 
> Now, I'll wait for Willy's hashes since I can't drill down on
> Linus' 2.6 tree beyond 2.6.x.

OK I'm attaching two files, one computed with the initial 002 perms and
a second one with the new 022 perms. I don't precisely know when the perms
changed, hence the two files. I noticed that 2.6.25 was still 002, and that
2.6.32 was 022. In between I don't know. Note that I'm missing some tags
(at least 2.6.35.12 and a few 2.6.33.x and 2.6.34.x).

The file is formated to be easily used with "md5sum -c" that dirty way
(once hashes are split/joined at the location where the umask changed) :

  cd /path/to/mirror/2.6
  cp linux-*.tar.gz /tmp
  cd /tmp
  gunzip linux-*.tar.gz
  md5sum -c expected-hashes.md5

It would be nice if someone with an access to a mirror could check the
perms of *every* tarball so that we can establish the definitive list
of signatures. I'm pretty sure the umask history is not linear. For
instance, I'm pretty sure I did not change the umask in my config when
releasing 2.6.27.x kernels and it seems like Greg did not do this either
so we have 2.6.27 022 and 2.6.27.x 002. Something like this might do it
(untested) :

  for i in linux-*.tar.gz; do
    set -- $(tar tvf $i|head -1)
    [ "$1" == "drwxrwxr-x" ] && echo "$i 002" || echo "$i 022"
  done

Hoping this helps a bit.

Willy


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="expected-hashes-002.md5"

b390eb0350b4f953a53c16dd5c28810e  linux-2.6.11.tar
2aeacc403998f8868a14c6bfde2355cb  linux-2.6.12.tar
f00810aacdbdcbe313b266172595b81c  linux-2.6.13.tar
ff5ad004e49d7ec7adc8b0dd5161736b  linux-2.6.14.tar
183e68cec3f221e4240b8acb0ac2b27d  linux-2.6.15.tar
3437d1e2944a86ca2b31d9b34664df0b  linux-2.6.16.tar
fbca10e30d7df32e87677f39d470b911  linux-2.6.17.tar
4ff78d8a1b1a5fc93760f3d2e49cb709  linux-2.6.18.tar
dbbf2847a6c76aa730bada4018ea4529  linux-2.6.19.tar
3905ab26c24c974e97eee4628ba1f2eb  linux-2.6.20.tar
c550ea5cee783951006450caa3dd3f95  linux-2.6.20.1.tar
3865227516b1ed115dcf52eda4ff1ad8  linux-2.6.20.10.tar
235e4c9dda5c423ac3ccd3aee7587553  linux-2.6.20.11.tar
8d9cc27403c29355549998b7966d6350  linux-2.6.20.12.tar
7331349a0e0fe5dbd230fb10900846f4  linux-2.6.20.13.tar
8e7be87759f3ead0852137e366c34a90  linux-2.6.20.14.tar
7bad3d284c2cbbaed0d2338f81e76859  linux-2.6.20.15.tar
25a1013fabd489d302f71bf3cb1837b3  linux-2.6.20.16.tar
5259b132a710eacc1e7489129f3b9e0f  linux-2.6.20.17.tar
4af3439c081f86b68a30d0bd447179c3  linux-2.6.20.18.tar
8bee08600da3f46bce0d2f15b1e3b68e  linux-2.6.20.19.tar
61056db1f9194d0a153ece9572200b4a  linux-2.6.20.2.tar
eb1b62690aa859f6d1deb70695e253a0  linux-2.6.20.20.tar
f85b1a1337f825832d1b39d1c62f457f  linux-2.6.20.21.tar
32820a679e81cdeb454f54d0994cf968  linux-2.6.20.3.tar
dda6d62ecfcfd5d0f2d7ae9bd1107b6b  linux-2.6.20.4.tar
c39381da208d5c15a2710673df5654fc  linux-2.6.20.5.tar
60065c3db7d5ebe97cef36022933ca0d  linux-2.6.20.6.tar
4352dedea3918d2c7d3a059bb00aa580  linux-2.6.20.7.tar
b26f5458b175e3b935586c433aa82c8d  linux-2.6.20.8.tar
12bf096a9ec27317a7fd0bf5241aa86d  linux-2.6.20.9.tar
53957189a9f2a382973c1063bd2e8954  linux-2.6.21.tar
c081d29d0c6ff1b61fd962b8259ecbc6  linux-2.6.21.1.tar
78d892b513b1b323ad12e3d3c69f6dbb  linux-2.6.21.2.tar
26b27b1aacaac870c94c3ce14155489c  linux-2.6.21.3.tar
562dbfe628d7f4ec5be02f2eee444209  linux-2.6.21.4.tar
4c778ee298cba1ba82d8f8ec00959f3d  linux-2.6.21.5.tar
3fc9cbc5f1eabdb79f0f819785aa79ee  linux-2.6.21.6.tar
d4efe4b192ca2be608b75a881ebca902  linux-2.6.21.7.tar
1db7e438e6a88f0d7588226a75d109c2  linux-2.6.22.tar
93e4955063c604799affa171cb6370d4  linux-2.6.22.1.tar
2dc8fd7f16668e1997a74a1e731febe6  linux-2.6.22.10.tar
57eb4df5f3863be6c6be405eb8a97c1a  linux-2.6.22.11.tar
055c7b258abb9489dbced86537c7dc4e  linux-2.6.22.12.tar
c1f411391548652149ea78afd7ffd026  linux-2.6.22.13.tar
ee15acfef4c0e9b787816546129c34a8  linux-2.6.22.14.tar
159067c422109e1b56e43fdf34e049f7  linux-2.6.22.15.tar
cf84f4aca3f11062968b5ce2351560c3  linux-2.6.22.16.tar
18a6b5c1759d2ed3d2552767d76329a0  linux-2.6.22.17.tar
b64d9b8f3c050692538ec941cc6ffd2c  linux-2.6.22.18.tar
5d5f55c4a794af96dfb7de2114755bba  linux-2.6.22.19.tar
5af3437e6ff97f9920d227681f1c7b5e  linux-2.6.22.2.tar
65e5a5d73e732ef3657554b2eeeb3547  linux-2.6.22.3.tar
d2294a1e23ef416c0b03cfb84acccd3f  linux-2.6.22.4.tar
34bfb927e95b7645ecace1becf492b09  linux-2.6.22.5.tar
a610d656962ebfbd46efd96ce0a96c66  linux-2.6.22.6.tar
d89f77ec176b0eab0be04ecdd06c1a2f  linux-2.6.22.7.tar
3b49a858cd506f320fa24adcec47c8ab  linux-2.6.22.8.tar
db2827199bfa42595a25bdad5e6fe500  linux-2.6.22.9.tar
534de4be852986f77cf75b2c27b797b3  linux-2.6.23.tar
37991d8ae19d709b63c95fb84c50ac30  linux-2.6.24.tar
0772dbf15ef73fe5cb64c91101896b7a  linux-2.6.25.tar
ca288f8d0a47a31a2007da996212dace  linux-2.6.25.1.tar
29fbcbf3fa504b000e6b405c681e91eb  linux-2.6.25.10.tar
225c43654b864c303822385572e8df9d  linux-2.6.25.11.tar
f5d46c6ae6d2a97f8d54610d8a71665b  linux-2.6.25.12.tar
d2affb4524db60f4e0c8c79a01fc565b  linux-2.6.25.13.tar
39380a57e0d2826acc72e16e0d0bbe86  linux-2.6.25.14.tar
32c56b46350368ca97f0afc4dc291e4d  linux-2.6.25.15.tar
9701b00fedc1d674db536adc5e5ddf11  linux-2.6.25.16.tar
47b63e5d2f59ea4f945fc954ef4aac29  linux-2.6.25.17.tar
a26142b7c3b02860bc1bb2eddaf621e3  linux-2.6.25.18.tar
78273a08ffe44e3a85a0574e7d67f367  linux-2.6.25.19.tar
5199cfe55c13162661ec4035272e072d  linux-2.6.25.2.tar
6eea4d0acd22b88c124ce2dfe70a716a  linux-2.6.25.20.tar
5857b5bb21fe8d41460e89b87b9f5362  linux-2.6.25.3.tar
e64c0ae28293e0c578a029af170150d2  linux-2.6.25.4.tar
828cad924870acb9643bf4bb0f72cc92  linux-2.6.25.5.tar
6e0ee8c95c9aa2b619dd9159c1eab57d  linux-2.6.25.6.tar
9ccdda12b747a122a94ac30e735ba9f9  linux-2.6.25.7.tar
b1adac6690deea86340d5e18fd7bee7c  linux-2.6.25.8.tar
b737d23e536e7f9bd93a5888656c6a87  linux-2.6.25.9.tar
fc8cde1368ab6ed0e3f04008b29bea4d  linux-2.6.26.tar
f4a2389af9ab16b0625578217934e2f0  linux-2.6.27.tar
b02d388a1b5179fd40139bdc6d5a2ccd  linux-2.6.27.1.tar
18abcd2d7d157c1cb02bc77f9c2834e7  linux-2.6.27.10.tar
38c7b9727f34961d25471cf3962079fd  linux-2.6.27.11.tar
54f8917ddd5b8c0b89e58aa348a725f0  linux-2.6.27.12.tar
18dfed96ccf2ca4874953d5a2618ab63  linux-2.6.27.13.tar
b8721dbdace184d588d68dc5639feb9c  linux-2.6.27.14.tar
c7e39c082d49e20cf5da354e3e603214  linux-2.6.27.15.tar
81462897e5ddab2c09f79f9c58c6bacf  linux-2.6.27.16.tar
5a03443dcef39fc7b6afa3d7ab9e22b4  linux-2.6.27.17.tar
8e272f65bf0c7dc73c57d85dc6c75b9f  linux-2.6.27.18.tar
61e60b5c2fe91f28da019a078be8d0a5  linux-2.6.27.19.tar
104577a9cb43ee17832e6079a05bb37d  linux-2.6.27.2.tar
8324c79cc242afdfe86f1e5964e49d60  linux-2.6.27.20.tar
13a0e7ca645dcc462a2c0f4e265a6760  linux-2.6.27.21.tar
7f76aff66928dab42db7fd9c963b0813  linux-2.6.27.22.tar
399cf04ceb5f05eddea8a9782cc2ddab  linux-2.6.27.23.tar
2cb77153d209a55367edc8398f4afa88  linux-2.6.27.24.tar
bb963116a132b885f4902ddc1e561920  linux-2.6.27.25.tar
0bf3c35f3807bdd95a3e74d691392afd  linux-2.6.27.26.tar
3e4f73295dc177201ab546bcb360feae  linux-2.6.27.27.tar
e52c78805e8f44af814f9e76613e04b2  linux-2.6.27.28.tar
5a7de732a819d219f51fe5b47f645555  linux-2.6.27.29.tar
88b3887f45666600820778d4d10d4d86  linux-2.6.27.3.tar
a19b497d70fe55519e1fc158ce5afe0d  linux-2.6.27.30.tar
f5bd4a54000bbc19b319cd1c084c0b1a  linux-2.6.27.31.tar
7321d15dcab7a704bf4bb78a0bc0c599  linux-2.6.27.32.tar
55fcebf49f18a06e24468d5b4b70dfd9  linux-2.6.27.33.tar
7d8eb3d81e947465a6c0deb52839b20b  linux-2.6.27.34.tar
1289c724be385e99e89593ea39835ad9  linux-2.6.27.35.tar
ee2a5457dcb337956bc03059fc92c2a1  linux-2.6.27.36.tar
e90869665b6e4860828c0f7097aaa513  linux-2.6.27.37.tar
763dbfd6558ce5dee3ae8ce720b2645c  linux-2.6.27.38.tar
dc579c8445954eb512977b28224dfef9  linux-2.6.27.39.tar
dbb8b8b58962acf4945a5d73810330d6  linux-2.6.27.4.tar
a75c56fb79c601fa6a8ee753672895ef  linux-2.6.27.40.tar
832c145c0ad862d038b41c6a09e19e6f  linux-2.6.27.41.tar
5df04b71553553d1e5833c65008425d5  linux-2.6.27.42.tar
50b70a5f28747b070bdfd0bcc7f9529b  linux-2.6.27.43.tar
07f9c9509becfdf6ddef4f142a2b87fd  linux-2.6.27.44.tar
5df8e25fcaaf9ec0b108c68d31c1f23a  linux-2.6.27.45.tar
feb0c66e8af4e3c73bb7675ad99633cb  linux-2.6.27.46.tar
a10aedc65ec24f5b9f5e7d2534adf94e  linux-2.6.27.47.tar
dab808dedf4eb7e1425cdb0b30a4c8cf  linux-2.6.27.48.tar
d0ec0912960ab79e90d228da7fac1d67  linux-2.6.27.49.tar
99b5eb960d4709d8eab162696d7601dd  linux-2.6.27.5.tar
ce3e327c7291fe271340eaf2904a4347  linux-2.6.27.50.tar
3256ec86d0249f6f0bf967718fd35363  linux-2.6.27.51.tar
ed87ed7d7fce749a3faf845c85880ef9  linux-2.6.27.52.tar
108d6b3f2c723bc4360e3bbbb2474aec  linux-2.6.27.53.tar
cc203656605a40fca27f90e993952788  linux-2.6.27.54.tar
28b6bb904578f3bbc3dafe22b0f3512a  linux-2.6.27.55.tar
d135df3b77fe7c83ecc369139719085a  linux-2.6.27.56.tar
8a6cc185e7c91835b12c85969a3f00f3  linux-2.6.27.57.tar
b9f88fc59a5b7dede53249eb1cf056d5  linux-2.6.27.58.tar
b13ed9fb91f415f16549da6b05cf0a55  linux-2.6.27.59.tar
921927e2cce7f3e59c4f76d54c77ffcb  linux-2.6.27.6.tar
da79852b3b31b665ddac1eaff1712747  linux-2.6.27.7.tar
10b609f0af0a4fcf0ed18e2d076d8310  linux-2.6.27.8.tar
b62bfd7ba8a13833440abb458267c8cd  linux-2.6.27.9.tar
e97b8459593e20a7bd2d75ecce4cd9a1  linux-2.6.28.tar
8354f1b9f6364047278aaa9a160e6010  linux-2.6.29.tar
3378af02af06b10b3725a7f90a1e2832  linux-2.6.29.1.tar
df3f8999068ca47425826f97643a9b01  linux-2.6.29.2.tar
0c32afeb514f2909950c10704ea1c251  linux-2.6.29.3.tar
3510ca1d830c8b9fcef92c258d0a4762  linux-2.6.29.4.tar
cef8e5a3bbf183e7ad3281b1f3bfe657  linux-2.6.29.5.tar
3d9def1cc78eac6271b54194434695e3  linux-2.6.29.6.tar
a1d93463120021669925776fcf94592e  linux-2.6.30.tar
1f57a5f8a65bd38e7b9c2f2c1ae32f66  linux-2.6.30.1.tar
bbc68779259558afca403ca041b49073  linux-2.6.30.2.tar
6a5963823ecfc432f36827d5c17b9cd0  linux-2.6.30.3.tar
9a3533d3a716913fdf7f8b73f1beae45  linux-2.6.30.4.tar
b446af3c919a4cf65008b61f75e88cd6  linux-2.6.30.5.tar
4d87e17f3b3448ce7e69afc9debf0efd  linux-2.6.30.6.tar
e5a18192355fc18831f83ad8338378f9  linux-2.6.30.7.tar
f6c70ebeaaa1e0f23cf4310bba9ac827  linux-2.6.30.8.tar
327a5876f9884ac4e2dd79b642790b4f  linux-2.6.30.9.tar
f3fa1f5cb17d43bdea3cb0b214ee16c4  linux-2.6.31.tar
0697e50b0515da0c94700a56acaf84f1  linux-2.6.31.1.tar
4e5ee234f4d1ce8a2a97e81d1c3e5e3e  linux-2.6.31.2.tar
f686666a2218afd13f2c6bc794919615  linux-2.6.31.3.tar
e2e84fc3cea9293517698f2af02e3698  linux-2.6.31.4.tar
a1518ae179af94eb840024655ed4471a  linux-2.6.31.5.tar
660348915031cc50ede9b6ae2028bf52  linux-2.6.31.6.tar
a0e27bc0c5a53a1a895c76d88a5acc1a  linux-2.6.32.tar
5be63bd57f8672db69198a8ec7a04637  linux-2.6.32.1.tar
32aa41fbc18fbe1cf1e8535e677c13a4  linux-2.6.32.10.tar
212f747ca5999b395bcc03799399b8ad  linux-2.6.32.11.tar
b73836b409909ba691e442a851221bab  linux-2.6.32.12.tar
1f72687582dd1bf5aa7d9a1b01ac11f5  linux-2.6.32.13.tar
8af1c02cefc69f902008b6d16e2a5f19  linux-2.6.32.14.tar
c86b467e8649d5b782e5c85d7bada2c3  linux-2.6.32.15.tar
34f9d86da519c3ac868bb6b9c0edf5fd  linux-2.6.32.16.tar
41fa851916eb3e208eb2d07d9a2edc20  linux-2.6.32.17.tar
e93ea8c463c761b6733ca9550de9d28d  linux-2.6.32.18.tar
baa03d63e6eb52c870ef5f4dee6bff81  linux-2.6.32.19.tar
cbd1bab8027a01ec42c28278879a7209  linux-2.6.32.2.tar
9b4b3ccbdb161284db7c50d8fa7a9cc4  linux-2.6.32.20.tar
4e2d3f2ca147c1d18a0c042bb39e8296  linux-2.6.32.21.tar
c1bbd1b7be8f5bc5b8ec845ba4cfa6d6  linux-2.6.32.22.tar
7706a8fa891540f5eaaf0b504505473d  linux-2.6.32.23.tar
e19d2bef8b40fe3870bb0b8e9bfa2f4b  linux-2.6.32.24.tar
1e8ea8d88db9ea220746c317c891c6d7  linux-2.6.32.25.tar
21db42cb4175753d6b702138b2d16035  linux-2.6.32.26.tar
f3b4b1aefc240a75b84ce8c83c1d8203  linux-2.6.32.27.tar
c63f9b5a3344f866620f6ae10be15881  linux-2.6.32.28.tar
a6546c1fad45fa336885860d31f89b9e  linux-2.6.32.29.tar
8dd90672223a82d8cbfa9bf0ecf6c70b  linux-2.6.32.3.tar
8b3e0d9612b61cdbf4a9a01566010fa4  linux-2.6.32.30.tar
5dcf526758804fa382f231073a442ebe  linux-2.6.32.31.tar
a3fd490344081ddc863c85e066c26de4  linux-2.6.32.32.tar
a22b0dd689764e1aa2abcbc4f3f38899  linux-2.6.32.33.tar
7c596527748f917b0df22321b83c9eb9  linux-2.6.32.34.tar
31b9c268a72f183b37a609ce1688ed33  linux-2.6.32.35.tar
21d809b12592e91d100f40ee9c415e94  linux-2.6.32.36.tar
88572d1d95f9417a93db60a954f3ce9c  linux-2.6.32.37.tar
75e4d93ea9c57c28acd169902c70ffe7  linux-2.6.32.38.tar
6d266224d3ff0d136b336228fe108f3a  linux-2.6.32.39.tar
2cf5b76b3aa71790215b45afcfa8906e  linux-2.6.32.4.tar
27cd2ab5f45c83effbca8f894b9bf9a4  linux-2.6.32.40.tar
3da56d911ae16e1d9d04d27e97140094  linux-2.6.32.41.tar
74189193fa0b44a74bfe31de2934396f  linux-2.6.32.42.tar
702e1151878c159021bfed717483d078  linux-2.6.32.43.tar
cc137ff7c3f9cd033bab9ddadfa09b9b  linux-2.6.32.5.tar
d1561434aa81622f6b17b72c8e00c226  linux-2.6.32.6.tar
c0fcd24b3b3783afefda8f77b0c95a03  linux-2.6.32.7.tar
2e09e2ecd521b5fb43cc577e88e98356  linux-2.6.32.8.tar
9e1ddce5bf49fbf740fe4967990b3f83  linux-2.6.32.9.tar
6fabba8f967b90f85e6ececa26531ddd  linux-2.6.33.tar
c604a96b1006c24da58237b9e55195a9  linux-2.6.33.1.tar
6453571f38b4dfaa602f7585a7616c48  linux-2.6.33.2.tar
a940c369b6d48fd3aea62d86d3a3b324  linux-2.6.33.3.tar

--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="expected-hashes-022.md5"

f2f5e85a40255599e4efecae1aad3ac1  linux-2.6.11.tar
7d26979a123817f8386c12c5abb0e20d  linux-2.6.12.tar
8ae2c8d9d4f5cab99d4d21019dddf6a4  linux-2.6.13.tar
8ee2b4548d71cfa1079ecc2e30723434  linux-2.6.14.tar
2c970565ab3d24d56501091757359bb8  linux-2.6.15.tar
57e8bf34d91002fe115e1846cce95fdf  linux-2.6.16.tar
74c9b87042b6065a56682d67f17c451c  linux-2.6.17.tar
fa24e3245d8cb475ebffba763912063c  linux-2.6.18.tar
2630dcec21807a23b8f3c1d3463a9537  linux-2.6.19.tar
1c3a2b5f69f773e1ce3f02b0f3abddfa  linux-2.6.20.tar
c53647f3dbfd0ffd9654a0ce98b8d291  linux-2.6.20.1.tar
c1895c4103b5be384bee66b753d36ac9  linux-2.6.20.10.tar
f66b86d42fc446f2d411131689967c93  linux-2.6.20.11.tar
18e19f4cc550a39504e97193709153e5  linux-2.6.20.12.tar
171eb9fdd34f733e0922cd4b23071db5  linux-2.6.20.13.tar
482c40ff5cf7943f14592813c675d256  linux-2.6.20.14.tar
589d2a8a3c55e4ea72a62ad96aa1a414  linux-2.6.20.15.tar
8dcdeb70f40c510d722b860dafa09789  linux-2.6.20.16.tar
e6f79766425a02f118494c3eb6805bb0  linux-2.6.20.17.tar
6545281f0fb59df6570662d4161d3995  linux-2.6.20.18.tar
c08764a841602912d5515dabf35953b5  linux-2.6.20.19.tar
fe156af3eb690e4dad7481feb4a4f7d7  linux-2.6.20.2.tar
eb741f1bf898e4be5a8efde2a619cfaf  linux-2.6.20.20.tar
2152797bcda1ab3f7302a598bffb7c92  linux-2.6.20.21.tar
02e26f6b5c8cdb9bb6573612266d6a0c  linux-2.6.20.3.tar
1d399bf99ace7118fdb0b69088e391a7  linux-2.6.20.4.tar
54bc2907ecbbc6c73c086d14fec1c55a  linux-2.6.20.5.tar
4300abbeb91cc50b48c086c2c329eab8  linux-2.6.20.6.tar
806bf4868c54b8492cb093f0cd281a1c  linux-2.6.20.7.tar
f5d2ad11c38f09127140c3777fcfb824  linux-2.6.20.8.tar
6bb0a333bd1d94b3eabacdd03971f1b1  linux-2.6.20.9.tar
7965f0be6b6c1a4ff4e34336ba25d975  linux-2.6.21.tar
b87bffbddced0cbe25af2a3f72bab13c  linux-2.6.21.1.tar
623bacd2f2c231fc8edf2292a007be9b  linux-2.6.21.2.tar
e74b18f8e76943550f8534b2742f864e  linux-2.6.21.3.tar
28ad35c0a93b954ec3316547122a5bbf  linux-2.6.21.4.tar
3545e91362d563f6ff9924b695f533f5  linux-2.6.21.5.tar
d60d8d57f3d82c102324d8b729c596d0  linux-2.6.21.6.tar
021f3468f5e0bd7a5bee8469d13840f0  linux-2.6.21.7.tar
2edfd190ac09c0e5b998ab8514488cfa  linux-2.6.22.tar
b789c174edfd1c34a2c531b64e38ad64  linux-2.6.22.1.tar
3301c3caecf8f7f990d9accdab177ade  linux-2.6.22.10.tar
c6c542f71792080dbff1dcc583d4a518  linux-2.6.22.11.tar
aff348bca24814f561a8e5a5c908bcce  linux-2.6.22.12.tar
ab13c640b6420716feee1b520dd6b4b4  linux-2.6.22.13.tar
b82a63dcdae3ad14647cce9c43f51f3b  linux-2.6.22.14.tar
306cfe6a9d8cfaf195f3595ea269fb28  linux-2.6.22.15.tar
81cb91f23b2b21c94352eeb6ecb8082a  linux-2.6.22.16.tar
84e73c1861593689d20bc1d3c38d3e86  linux-2.6.22.17.tar
43e31521a204bc720c15d517aa034d8f  linux-2.6.22.18.tar
bc41726a2e88de45aea7ffc8e11fd5b7  linux-2.6.22.19.tar
46b9113ae5afb91c19a5fa63229982dc  linux-2.6.22.2.tar
633cde0652edd63a649058793943977f  linux-2.6.22.3.tar
805fd09a107609a9d5ea4f2a2631fe95  linux-2.6.22.4.tar
ad55bbb9edee79e6f1c3955d66cad35f  linux-2.6.22.5.tar
ec4ee470dfbe2f0d49b01cceb3a901eb  linux-2.6.22.6.tar
d1fd246bfef1afe7a971598832f75e7e  linux-2.6.22.7.tar
2b870ab6c247b7a16c3592bc2c90617c  linux-2.6.22.8.tar
d088d683b62911711ab05aa72bcccbcb  linux-2.6.22.9.tar
853c87de6fe51e57a0b10eb4dbb12113  linux-2.6.23.tar
19aee46bdd4577a4ba14ba51284cf791  linux-2.6.24.tar
2b8b848fcae4e1d4fb56c897e3a40c21  linux-2.6.25.tar
4f0443a7a1945c78ee7aefd65daab63b  linux-2.6.25.1.tar
3710353e8fb9ec0e5b7976946e8ad74a  linux-2.6.25.10.tar
46f205cf295de0722681c4a697913b17  linux-2.6.25.11.tar
0a9a7a979f1357430200ff19dd8ab9f9  linux-2.6.25.12.tar
0ce23a617201a6a77e00a05386a63b49  linux-2.6.25.13.tar
02aefcf5bf1f83bb8183d60f3554a876  linux-2.6.25.14.tar
edeb4d638af1061b1aa935d86d1eff21  linux-2.6.25.15.tar
21758a05e5ec21c4d26951de2fca5dc9  linux-2.6.25.16.tar
063547ad9ec9c7788c5e8fc85bf01dc4  linux-2.6.25.17.tar
9c862120cdcf5ab5dae6096dcc5e8e3e  linux-2.6.25.18.tar
272fcd11f8afb4e15ea2f9ed7701684c  linux-2.6.25.19.tar
0b21683d683c61caf7ed6a31148a730c  linux-2.6.25.2.tar
e34abaec1ead16ba8a37bc2d1af58235  linux-2.6.25.20.tar
8da85334dec70888ad7f5d9af383312c  linux-2.6.25.3.tar
4f93d14b812947bf5c3c714497abf981  linux-2.6.25.4.tar
f5589bf75e12ffa4a6d7c1409121fc25  linux-2.6.25.5.tar
7bc58e34dac2d19c87b0f6cf91701b8a  linux-2.6.25.6.tar
ae98119abe7c6d2ae3434e6128df2d0e  linux-2.6.25.7.tar
91c56c460e41c6cd3f51c207a21d8f3c  linux-2.6.25.8.tar
21d1a646fefc788ed6f350b6fa9bfee4  linux-2.6.25.9.tar
75aa7264f67777b0adf16bb38b2b90fa  linux-2.6.26.tar
f9fb49f756036a34d26eee85240ff8fb  linux-2.6.27.tar
8070c075076bfd9a127287b4971e805b  linux-2.6.27.1.tar
87974d79868688bfde542ae53a1b3125  linux-2.6.27.10.tar
2cbcf84c85d9c59e77fa914bd6bba761  linux-2.6.27.11.tar
b49d9e95fe93f446e01d4518b60bab69  linux-2.6.27.12.tar
570af87146476f11510326df0d8b3984  linux-2.6.27.13.tar
1f7905e190b577e05577ae69a87cfdd0  linux-2.6.27.14.tar
1f9774d0d3905f7c4c26eccfcbd39a32  linux-2.6.27.15.tar
a25b9ff42e4118dadbf91dab177cf729  linux-2.6.27.16.tar
11dda14a935da891297aad6ac63963b9  linux-2.6.27.17.tar
6c52ca1c6d7873c7b1c7137604fae0fb  linux-2.6.27.18.tar
5364290f657196744241a03083035701  linux-2.6.27.19.tar
3b4cbe544080882fecb9253ab4b86302  linux-2.6.27.2.tar
7ca7c36744e934af1727edb8da469c06  linux-2.6.27.20.tar
615bfa2d1d5efd8979afb44b564e7ef6  linux-2.6.27.21.tar
4ff50b881758279609c46bd9d1836559  linux-2.6.27.22.tar
74563dfe5e3d75ac620cd7b3e932078e  linux-2.6.27.23.tar
9c9ec6ac35b0526c26ec0b1ac78602d2  linux-2.6.27.24.tar
964946e63215d1ba1e54443e04c152dd  linux-2.6.27.25.tar
0e5bcbc4dc72f824a167b6a6ccaf9827  linux-2.6.27.26.tar
76f8c62fd84fe5bd1cbc127e480ac874  linux-2.6.27.27.tar
0a71df8639d914466dd6aaa3eb41aae9  linux-2.6.27.28.tar
522242271924801f5733d58a78191317  linux-2.6.27.29.tar
ea861bd74b8557efe9eff8fbecdece93  linux-2.6.27.3.tar
469eed11a3d554d505a9c45320850e63  linux-2.6.27.30.tar
b2c2b26d24a1adc627964ae38ece6d8a  linux-2.6.27.31.tar
89e8b659a186973968e38ae954a4eb94  linux-2.6.27.32.tar
ac62902bae7986900cb1fc6d6a515069  linux-2.6.27.33.tar
f7f09bed6ba9b43b4869acccce651799  linux-2.6.27.34.tar
04f97cb04659e5766c3d6d98a4a61b49  linux-2.6.27.35.tar
13e359ac044ab939a1099527d9273c0e  linux-2.6.27.36.tar
42840afc0212c344d7da63e324578194  linux-2.6.27.37.tar
1c362fc95fce9d75ad1cb5d2008bd0e5  linux-2.6.27.38.tar
35270ba7035121ba412a1b0c9ad858c6  linux-2.6.27.39.tar
fa68f25239bd1749e4964a1fbab799de  linux-2.6.27.4.tar
b46cd8e6cbedac278897e162b6d0ec9a  linux-2.6.27.40.tar
e2b58b73ceba4c87c67d016721d9a114  linux-2.6.27.41.tar
758ad666cfb701bafe6fc629a32198df  linux-2.6.27.42.tar
40b4bf9a28021d66d78a08679b8b83ca  linux-2.6.27.43.tar
02838773b9b90590e13b0d1a06a4ac9f  linux-2.6.27.44.tar
1387eee67e915ebb560db850dc3bbbd3  linux-2.6.27.45.tar
49f442f32325dde72aa36106308e6b79  linux-2.6.27.46.tar
6029c88ed971e0b0027da5dcc2c6279a  linux-2.6.27.47.tar
336ff978d5ae1b5423e7d9a32bbf8ddb  linux-2.6.27.48.tar
dc3733da9c995546ade6cb9bbee04ff4  linux-2.6.27.49.tar
f4905352c9554e66ca96ec204f0f9eaf  linux-2.6.27.5.tar
5ef7354428412a4ea1f75092e222d321  linux-2.6.27.50.tar
7030272c8c35ef0635fd0ec626bbf85b  linux-2.6.27.51.tar
b01521d39e2b1f9aabc5330553c0430f  linux-2.6.27.52.tar
d471e1ded08f9b2412c52e72cc84b8b3  linux-2.6.27.53.tar
f5af02a82c0b499ef96a42d77d60bfd5  linux-2.6.27.54.tar
82143acbd35fc038803c7b7b8e613dc4  linux-2.6.27.55.tar
a83cdc2128fc495cec962e7999b273aa  linux-2.6.27.56.tar
8e42fc7abc073732992d94de5fed687d  linux-2.6.27.57.tar
3e169f917524e59cb796b4c8b2798a18  linux-2.6.27.58.tar
1b8085b5a66ccbd0801ed8370ba090e6  linux-2.6.27.59.tar
35332c4ad162bd77f82df4c2d8c00338  linux-2.6.27.6.tar
1a0d2054b80f5816003c52d9bf0723b1  linux-2.6.27.7.tar
3c3febbd1db7a7b8ddfc6beb14255f3f  linux-2.6.27.8.tar
f775d1b1f8f6afac87f3c52af73b1b26  linux-2.6.27.9.tar
afb7b848123b8f2df42cf42f0845860f  linux-2.6.28.tar
f614a023dd7a9b38303a35aebedb3a4d  linux-2.6.29.tar
eb49381facbe064063ea3e57cfb4a906  linux-2.6.29.1.tar
d741e8ee0907382bbde85a38ae339306  linux-2.6.29.2.tar
d958cca6c8fdce6dc11fc41e70d5778f  linux-2.6.29.3.tar
d2a53cd35c4a0527932c7c558aa5fe40  linux-2.6.29.4.tar
62375464059dfd8f98345e560546de27  linux-2.6.29.5.tar
88820d065779ce517d03e6c19c9d3198  linux-2.6.29.6.tar
2bca7fef9e6aeaafcf4d34740c2a511e  linux-2.6.30.tar
48dd001c8abb29f6caa686ac5c1dbd58  linux-2.6.30.1.tar
41e301a9a711c98fadfdaace0780a31e  linux-2.6.30.2.tar
59cf51a5461eb418b7d6cc70eadea0d3  linux-2.6.30.3.tar
9b5bfc1bc2cf09efe9259f9257248828  linux-2.6.30.4.tar
0c31aa5f6d63d839672d905c659f87f6  linux-2.6.30.5.tar
3da8c653652dd312b5054eef32fdb9c3  linux-2.6.30.6.tar
9f7800ac2ccf8b6ed4dd588301483e01  linux-2.6.30.7.tar
10f187cd3037ef63b870471809bf7123  linux-2.6.30.8.tar
79668ae100b542b0484424c8ff84cd5e  linux-2.6.30.9.tar
153f6267e44f5d32a364aa61e2b8c537  linux-2.6.31.tar
dbc4419d2ea5063da881a55ec9a0cd12  linux-2.6.31.1.tar
bd0c7eb6ca9349f5ce36bc918e9f342d  linux-2.6.31.2.tar
d0034f4a1b64e3ec8e39c6282ecbbe4c  linux-2.6.31.3.tar
5c61245d5206c8264172f7b529da3ab7  linux-2.6.31.4.tar
42a2f9fdbc51153d4ebf12248b388f17  linux-2.6.31.5.tar
87d1bbe2e52c7926aab04216ebf06aff  linux-2.6.31.6.tar
d1fef908e3b72c37b925e1a399d1a035  linux-2.6.32.tar
fbb0b53fd5f988a5045eb9ff0cf00c70  linux-2.6.32.1.tar
797b6fc1597310f439e206db4bb27a95  linux-2.6.32.10.tar
4c1d7f4e153aebcd9d11963f8622dbb6  linux-2.6.32.11.tar
f10c5ee16cd40b43dba061dfbaba986d  linux-2.6.32.12.tar
2245a91ee485ab622a0143bc4d356f84  linux-2.6.32.13.tar
e3dc9f94dc0b0758332e9d271509cb33  linux-2.6.32.14.tar
3939d945e2ca1f9a37d46c32c272a872  linux-2.6.32.15.tar
dfa36a1c0d21b94ba55510529244825a  linux-2.6.32.16.tar
54a703b26431ed63abeca026df0a289a  linux-2.6.32.17.tar
eb555d35de13dca895e764deb52da0f7  linux-2.6.32.18.tar
7f89366a08f21d0d22dd407153fcc3b9  linux-2.6.32.19.tar
715105f99c1c441251bad5f00e7f839d  linux-2.6.32.2.tar
6ce7e916ac84d00cef09bcbbb6ef7f16  linux-2.6.32.20.tar
609a992d3bbc0fd7ef96602053ac0634  linux-2.6.32.21.tar
f05a06b85c7859be85547ad2d1e1abe7  linux-2.6.32.22.tar
87f10b9d179aebdf57f7e852336492f2  linux-2.6.32.23.tar
581079e6aa1207aafe62aa2037bb5b50  linux-2.6.32.24.tar
6b6b653f08b9a2cee09b2efbd935edd5  linux-2.6.32.25.tar
eb0d49fb9de6720050db1f7da860d285  linux-2.6.32.26.tar
ef045b2aafa4baa7b146341016477bac  linux-2.6.32.27.tar
07052ac799fdc6edc591637c482f42e9  linux-2.6.32.28.tar
fe8f32125281589fd8f3dab91e7fafe1  linux-2.6.32.29.tar
da4b91ef37cb14c04f9ee3dcdf0a4cf2  linux-2.6.32.3.tar
fda8f11240d61fd8f669894b140e5b6d  linux-2.6.32.30.tar
e89884177b8e156cf6b8f0f8e2aac303  linux-2.6.32.31.tar
37e8c1c80bd65d5cc4a991f45dd0067b  linux-2.6.32.32.tar
0f2e9723c2821cb435041dd7944565fc  linux-2.6.32.33.tar
97aaabc9df34d09e569eacbfe4e43377  linux-2.6.32.34.tar
a133670d718d19944b5b33814b9b92a3  linux-2.6.32.35.tar
d3519959ea3d63f0176c001625661f6e  linux-2.6.32.36.tar
561265c5b5393f15302f46c20259cbaf  linux-2.6.32.37.tar
8317b49e04e0c85ad63b68df6b79b326  linux-2.6.32.38.tar
482cd728efd74c4337144276dd3807ad  linux-2.6.32.39.tar
3d711da17861729c3dcaa5f33c3d0ad2  linux-2.6.32.4.tar
2ac2a01c5b81f8226ca6f7bf5c316c86  linux-2.6.32.40.tar
cd72c28909bdf666d22a35a97b583a5e  linux-2.6.32.41.tar
1f1b463e59c4354ce58510b3f975d2c7  linux-2.6.32.42.tar
db32d5d6478de235462d0952ae183bc8  linux-2.6.32.43.tar
7855f7a563a78be687ef15742fe02cb0  linux-2.6.32.5.tar
9330517770a6fbac7e83a009c80e2764  linux-2.6.32.6.tar
05272bb905652db15bfa5c9b1d09d706  linux-2.6.32.7.tar
f073b45bdf76126b9687f7a929131a52  linux-2.6.32.8.tar
29f6f3d95c7922871ba2b1b3d7370a11  linux-2.6.32.9.tar
7fb6c834df94d78ad1dc118ba98bab21  linux-2.6.33.tar
b2e6e14d8d7649d646662484fc649c64  linux-2.6.33.1.tar
ba7df33c0624858c017ce9d483026a1c  linux-2.6.33.2.tar
5db2fe84a481b82b18138d89b90d9533  linux-2.6.33.3.tar
daeb9d57e70ec0b04ac9d5fa13f3fd47  linux-2.6.33.4.tar
ef8a509eec6cb18e729ce79c824eb184  linux-2.6.33.5.tar
b36063fb6a50e736dc65f1798b4ec12f  linux-2.6.34.tar
76e96f2df4eeea351787c65b3b264986  linux-2.6.35.tar
b08724cbafa37379d7a4bca54637e203  linux-2.6.35.1.tar
b8bdcb17f235805dd3c5bdb6e51e672a  linux-2.6.35.10.tar
4facab5d0b2099b3d49142d862c1bedf  linux-2.6.35.11.tar
e07069bc483e1f222ed676689191f0e4  linux-2.6.35.2.tar
9092ada8d2f742022689c8ef556df867  linux-2.6.35.3.tar
926e86cdbc597a6d002de9084882dde9  linux-2.6.35.4.tar
3617b069536ebe589590577875479f9d  linux-2.6.35.5.tar
33d48a4a4f857e702b6e88a11041135e  linux-2.6.35.6.tar
2ab3b2bf1fd6943c4e502b790318cefb  linux-2.6.35.7.tar
32fc3af98d7f190b16005ad3bfc5113f  linux-2.6.35.8.tar
6f8e194a28b3bb1829a1fc6f022f4221  linux-2.6.35.9.tar
2f4d3b5d66aa1c1465e0c05e3c5f36ac  linux-2.6.36.tar
943a4f25288d86b1dbf7808eb539bd42  linux-2.6.37.tar
0e705fd53756f7bddcf6e4bb3f18458b  linux-2.6.38.tar
833d224ee42ddc1e7c2d256368b5d7b3  linux-2.6.39.tar
4de04c36ae76c37269f156c13e75aa73  linux-3.0.tar

--7JfCtLOvnd9MIVvH--
